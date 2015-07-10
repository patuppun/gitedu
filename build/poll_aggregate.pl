#!/usr/local/bin/perl
use strict;
use FindBin qw($Bin $Script);
use lib "$Bin/../perllib";

use Getopt::Long;
use Data::Dumper;
use JSON;
use Gerrit::REST;

our $tools_dir = "$Bin/..";

require "$tools_dir/perllib/delivery.pm";

our $debug = 0;
my $poll_period = 60;
my $window = 4*60*60;

my $gerrit_server = 'gerrit-ccxsw.rtp.broadcom.com';
my $gerrit_url = "http://$gerrit_server:8080";
my $gerrit_project;
my $gerrit_skip_project;

my $gerrit_branch = '';

my $username = '';
my $password = '';
my $site = 'rtp';

# Load commandline options
GetOptions('debug'          => \$debug,
           'poll=n'         => \$poll_period,
           'window=n'       => \$window,
                            
           'gerrit=s'       => \$gerrit_server,
           'project=s'      => \$gerrit_project,
           'noproject=s'    => \$gerrit_skip_project,
           'branch=s'       => \$gerrit_branch,
           );

my @gerrit_projects = split(',', $gerrit_project);
my @gerrit_skip_projects = split(',', $gerrit_skip_project);

sub debug(@) { msg(@_) if ($debug) }
my $debug_opt = $debug ? '--debug' : '';

# Start of main program
my $start_time = time();

# load username/password from .netrc file
unless ($username) {
   if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
      foreach my $line (<NETRC>) {
         chomp($line);
         if ($line =~ /^machine $gerrit_server login (.*?) password (.*?)$/) {
            $username = $1;
            $password = $2;
            last;
         }
      }
   }
}
unless ($username) {
   msg("No username configured...\n");
   exit 1;
}

# connect to Gerrit
my $gerrit = Gerrit::REST->new("http://$gerrit_server:8080", $username, $password);

# list of changes to ignore for this aggregation window
my %aggregate_skip = ();

# Loop until window is exausted
msg("Starting..\n");
while (time() < ($start_time + $window)) {
   my $loop_time = time();
   my $rc = 0;
   # connect to gerrit server and fetch changes
   msg("Fetching changes from Gerrit..\n");
   my $project_opt = join('+OR+', map {"project:$_"} @gerrit_projects);
   $project_opt = (@gerrit_projects > 1) ? "+($project_opt)" : "+$project_opt";
   my $noproject_opt = join('', map {"+-project:$_"} @gerrit_skip_projects);
   my $branch_opt = $gerrit_branch ? "+branch:$gerrit_branch" : '';
   my $gerrit_query = "/changes/?q=status:open$project_opt$noproject_opt$branch_opt";
   debug("Gerrit Query: $gerrit_query\n");
   my $changes = eval { $gerrit->GET($gerrit_query) };
   if ($@)
   {
      msg("Error: ", $@->as_text, "\n");
      $rc = 1;
   }

   unless ($rc) {
      my %projects;
      foreach my $change (@$changes) {
         $projects{$change->{project}} = {} unless defined($projects{$change->{project}});
         $projects{$change->{project}}->{$change->{branch}} = {} unless defined($projects{$change->{project}}->{$change->{branch}});
         $projects{$change->{project}}->{$change->{branch}}->{$change->{_number}} = $change;
      }
      debug(Dumper(\%projects));

      unless (keys(%projects)) {
         msg("No more changes to watch.\n");
         exit;
      }

      # Iterate through each project
      foreach my $project (sort(keys(%projects))) {
         msg("Project: $project..\n");
         # load the project's configuration
         my @project_config = &remote_file($site, $project, 'refs/meta/config', 'project.config');
         my %project_config = &parse_inifile(@project_config);
#         debug(Dumper(\%project_config));

         unless (defined($project_config{"label \"Build-Verification\""})) {
            msg("\tNot configured for Continuous Delivery, skipping..\n");
            push @gerrit_skip_projects, $project;
            next;
         }

         # load the configuration from the master branch
         my @master_buildlist = &remote_file($site, $project, 'master', 'buildlist.ini');

         my @pending_changes;

         foreach my $branch (sort(keys(%{$projects{$project}}))) {
            msg("$project->$branch..\n");
            # load the configuration from the target branch
            my @branch_buildlist = ($branch eq 'master') ? @master_buildlist : &remote_file($site, $project, $branch, 'buildlist.ini');

            # determine which configuration is most applicable to this change and process the ini file
            my @buildlist = @branch_buildlist ? @branch_buildlist : @master_buildlist;
            my %config = &parse_inifile(@buildlist);
            print Dumper(\%config) if ($debug);
            my $delivery = &delivery_section($branch,\%config);

            my $aggregate_pending = 0;

            # sort changes into build and test and delivery
            my %merge = ();
            my %aggregate_start = ();

            my %aggregate_build = (approved => {},
                                   recommended => {},
                                   rejected => {});

            my %aggregate_test = (approved => {},
                                  recommended => {},
                                  rejected => {});

            foreach my $changeid (sort(keys(%{$projects{$project}->{$branch}}))) {
               if ($aggregate_skip{$changeid}) {
                  msg("$changeid: Change marked as blocked...\n");
                  next;
               }

               my $gerrit_query = "/changes/$changeid/detail?o=DETAILED_LABELS&o=DETAILED_ACCOUNTS&o=MESSAGES&o=CURRENT_REVISION&o=CURRENT_FILES&o=CURRENT_COMMIT";
               debug("Gerrit Query: $gerrit_query\n");
               my $change;
               my $count = 0;
               until ($count >= 5) {
                  $count++;
                  $change = eval { $gerrit->GET($gerrit_query) };
                  if ($@) {
                     msg("$changeid: Error: $@->{content}\n");
                     sleep(5*$count);
                  }
                  last if ($change);
               }
               debug(Dumper($change));

               msg("Processing change $project->$branch->$changeid..\n");

               if (&label_status($change, 'Merge', 1)) {
                  $merge{approved}->{$changeid} = $change;
                  msg("$changeid: Change marked for forced-merge...\n");
               }
               elsif (&label_status($change, 'Merge', -1)) {
                  $merge{rejected}->{$changeid} = $change;
                  msg("$changeid: Change blocked from merge...\n");
               }
               else {
                  # only if aggregate build ready
                  if (&label_status($change, 'Build-Verification', 2) &&
                      &label_status($change, 'Test-Verification', 2) &&
                      &label_status($change, 'Static-Analysis', 1) &&
                      &label_status($change, 'Code-Review', 2)) {

                     # if individual tests complete, determine aggregate status
                     if (&label_status($change, 'Aggregate-Build', 2)) {
                        $aggregate_build{approved}->{$changeid} = $change;

                        # if aggregate build complete for this change, look at test status
                        if (&label_status($change, 'Aggregate-Test', 2)) {
                           msg("$changeid: Change ready for delivery...\n");
                           $aggregate_test{approved}->{$changeid} = $change;
                        }
                        elsif (&label_status($change, 'Aggregate-Test', 1)) {
                           msg("$changeid: Aggregate-Test in progress...\n");
                           $aggregate_test{recommended}->{$changeid} = $change;
                        }
                        elsif (&label_status($change, 'Aggregate-Test', -1)) {
                           msg("$changeid: Failed Aggregate Test...\n");
                           $aggregate_test{rejected}->{$changeid} = $change;
                        }
                     }
                     elsif (&label_status($change, 'Aggregate-Build', 1)) {
                        msg("$changeid: Aggregate-Build in progress...\n");
                        $aggregate_build{recommended}->{$changeid} = $change;
                     }
                     elsif (&label_status($change, 'Aggregate-Build', -1)) {
                        msg("$changeid: Failed Aggregate Build...\n");
                        $aggregate_build{rejected}->{$changeid} = $change;
                     }
                     else {
                        msg("$changeid: Ready for Aggregation...\n");
                        $aggregate_start{$changeid} = $change;
                     }
                  }
                  else {
                     msg("$changeid: Change not ready for aggregation...\n");
                     msg("$changeid:    Missing Build-Verification +2\n") unless (&label_status($change, 'Build-Verification', 2));
                     msg("$changeid:    Missing Test-Verification +2\n") unless (&label_status($change, 'Test-Verification', 2));
                     msg("$changeid:    Missing Static-Analysis +1\n") unless (&label_status($change, 'Static-Analysis', 1));
                     msg("$changeid:    Missing Code-Review +2\n") unless (&label_status($change, 'Code-Review', 2));
                     next;
                  }
               }
            }

            # if there are changes to merge
            if (keys(%{$merge{approved}})) {
               my @change_list;
               foreach my $changeid (keys(%{$merge{approved}})) {
                  my $change = $merge{approved}->{$changeid};
                  # only merge code that is Code-Review+2
                  next unless (&label_status($change, 'Code-Review', 2));

                  my $revision_num = $change->{revisions}->{$change->{current_revision}}->{_number};
                  my $rc = eval { $gerrit->POST("/changes/$changeid/revisions/$revision_num/submit", {wait_for_merge => "true"}) };
                  if ($@) {
                     msg("$changeid/$revision_num: Error: $@->{content}\n");
                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                     "Error submitting change for merge:\t$@->{content}\n",
                                     'Merge' => -1,
                                     );
                     next;
                  }
                  msg("$changeid/$revision_num: Submission Status = $rc->{status}\n");

                  if ($rc->{status} eq 'MERGED') {

                     my $msg = "Change merged with Merge+1:\n\n" . <<EOF;
<b>Change:</b>  <a href="$gerrit_url/#/c/$changeid/">$changeid</a> ($change->{change_id})
<b>Owner:</b>   $change->{owner}->{name} (<a href="mailto:$change->{owner}->{email}">$change->{owner}->{email}</a>)
<b>Status:</b>  $change->{status}
<b>Project:</b> $change->{project}
<b>Branch:</b>  $change->{branch}

<b>Commit:</b>  $change->{current_revision}
<b>Author:</b>  $change->{revisions}->{$change->{current_revision}}->{commit}->{committer}->{name} (<a href="mailto:$change->{revisions}->{$change->{current_revision}}->{commit}->{committer}->{name}">$change->{revisions}->{$change->{current_revision}}->{commit}->{committer}->{name}</a>)
<b>Date:</b>    $change->{revisions}->{$change->{current_revision}}->{commit}->{committer}->{date}

$change->{revisions}->{$change->{current_revision}}->{commit}->{message}

<b>Comment Log:</b>
---
EOF
                     foreach my $message (@{$change->{messages}}) {
                        next unless ($message->{'_revision_number'} == $change->{revisions}->{$change->{current_revision}}->{_number});
                        $msg .= <<EOF;
$message->{author}->{name} (<a href="mailto:$message->{author}->{email}">$message->{author}->{email})</a>
$message->{date}

$message->{message}
---
EOF
                     }

                     my %mail_args = (to => 'ccxsw-devops-force-merge-list@broadcom.com', 
                                      subject => "Forced-Merge Notification ($changeid): $change->{subject}", 
                                      msg => "<pre>$msg</pre>");

                     &send_mail(%mail_args);
                  }
               }
            }

            # if there are changes to deliver
            if (keys(%{$aggregate_test{approved}})) {
               my @change_list = ();

               foreach my $changeid (keys(%{$aggregate_test{approved}})) {
                  my $change = $aggregate_build{approved}->{$changeid};
                  my $revision_num = $change->{revisions}->{$change->{current_revision}}->{_number};
                  push @change_list, "$changeid/$revision_num";
               }

               my $changes = join(',', @change_list);
               msg("Aggregate-Test complete ($changes).\n");

               my @changes_merged = ();
               foreach my $change (@change_list) {
                  my ($changeid, $revision_num) = split('/', $change);
                  my $rc = eval { $gerrit->POST("/changes/$changeid/revisions/$revision_num/submit", {wait_for_merge => "true"}) };
                  if ($@) {
                     msg("$changeid/$revision_num: Error: $@->{content}\n");
                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                     "Error submitting change for merge:\t$@->{content}\n",
                                     'Merge' => -1,
                                     );
                     next;
                  }
                  msg("$changeid/$revision_num: Submission Status = $rc->{status}\n");

                  push @changes_merged, $change if ($rc->{status} eq 'MERGED');
               }

               if (@changes_merged) {
                  # load the configuration from the master branch
                  my @master_buildlist = &remote_file('RTP', $project, 'master', 'buildlist.ini');

                  # load the configuration from the target branch
                  my @branch_buildlist = ($branch eq 'master') ? @master_buildlist : &remote_file('RTP', $project, $branch, 'buildlist.ini');

                  # determine which configuration is most applicable to this change and process the ini file
                  my @buildlist = @branch_buildlist ? @branch_buildlist : @master_buildlist;
                  my %config = &parse_inifile(@buildlist);
                  print Dumper(\%config) if ($debug);
                  my $delivery = &delivery_section($branch,\%config);

                  if (defined($config{$delivery})) {
                     my $build_package = $config{$delivery}->{delivery_package};
                     my $delivery_notify = $config{$delivery}->{delivery_notify};

                     my $tag_prefix = uc($config{$delivery}->{development_phase});

                     if ($build_package) {
                        my @args = ("CCX_SOFTWARE");
                        push @args, "--procedureName \"" . (($Bin =~ /\/staging\// || $Bin =~ /_dev\//) ? 'Build (debug)' : 'Build') . "\"";
                        push @args, "--actualParameter \"Site=" . uc($config{$delivery}->{site} || $site) . "\"";
                        push @args, "--actualParameter \"Repo=$project\"";
                        push @args, "--actualParameter \"Branch=$branch\"";
                        push @args, "--actualParameter \"AutoTag=Y\"";
                        push @args, "--actualParameter \"TagPrefix=$tag_prefix\"";
                        push @args, "--actualParameter \"Type=build\"";
                        my $threads = $config{$delivery}->{build_threads} || 1;
                        push @args, "--actualParameter \"Threads=$threads\"";
                        push @args, "--actualParameter \"Package=$build_package\"";
                        push @args, "--actualParameter \"NotifyDelivery=$delivery_notify\"" if ($delivery_notify);

                        my $cmd = "/export/electriccloud/electriccommander/bin/ectool runProcedure @args";
                        debug("> $cmd\n");
                        my $jobnum = `$cmd 2>&1`;

                        if ($jobnum =~ /^\d+$/) {
                           msg("Submitting Delvery Build Job: $jobnum\n");
                           map {msg("\t$_\n")} @args;

                           my $message = "Job submitted for Delivery:\nhttps://eca-rtp-03.rtp.broadcom.com/commander/link/jobDetails/jobs/$jobnum";
                           foreach my $change (@changes_merged) {
                              my ($changeid, $revision_num) = split('/', $change);
                              next unless ($revision_num);

                              &gerrit_message($tools_dir, $debug, "$changeid/$revision_num", $message);
                           }
                        }
                        else {
                           msg("Error submitting job: $jobnum\n");
                        }
                     }
                     else {
                        msg("No build job necessary: Build package not configured.\n");
                     }
                  }
               }
               else {
                  msg("No changes merged..\n");
               }
            }
            # if there are tests in progress
            elsif (keys(%{$aggregate_test{recommended}})) {
               msg("Waiting for Aggregate-Test to complete (", join(', ', sort(keys(%{$aggregate_test{recommended}}))), ")...\n");
               push @pending_changes, keys(%{$aggregate_test{recommended}});
               next;
            }
            # if there are aggregate builds complete
            elsif (keys(%{$aggregate_build{approved}})) {
               msg("Aggregate-Build complete (", join(', ', sort(keys(%{$aggregate_build{approved}}))), ").\n");

               # don't process changes unless there is a configuration section in the buildlist ini file
               if (defined($config{$delivery})) {
                  # Submit Aggregate Test
                  my $build_job = '';
                  my @change_list = ();
                  print Dumper($aggregate_build{approved});

                  foreach my $changeid (sort(keys(%{$aggregate_build{approved}}))) {
                     my $change = $aggregate_build{approved}->{$changeid};
                     my $revision_num = $change->{revisions}->{$change->{current_revision}}->{_number};

                     my $change_build_job = '';
                     foreach my $message (@{$change->{messages}}) {
                        next unless ($message->{_revision_number} == $revision_num);
                        next unless ($message->{author}->{username} eq 'ccxswbuild');

                        if ($message->{message} =~ /Aggregate-Build\+2/s &&
                            $message->{message} =~ /jobs\/(.*?)\n/s) {
                           $change_build_job = $1;
                        }
                     }

                     if ($change_build_job) {
                        $build_job = $change_build_job unless ($build_job);
                        push @change_list, "$changeid/$revision_num" if ($build_job eq $change_build_job);
                     }
                  }

                  if ($build_job) {

                     my @args = ("CCX_SOFTWARE");
                     push @args, "--procedureName \"" . (($Bin =~ /\/staging\// || $Bin =~ /_dev\//) ? 'Test (debug)' : 'Test') . "\"";
                     push @args, "--actualParameter \"Site=" . uc($config{$delivery}->{site} || $site) . "\"";
                     push @args, "--actualParameter \"Repo=$project\"";
                     push @args, "--actualParameter \"Branch=$branch\"";
                     push @args, "--actualParameter \"Change=".join(',', @change_list)."\"";
                     push @args, "--actualParameter \"Type=aggregate\"";
                     push @args, "--actualParameter \"BuildJob=$build_job\"";

                     my $cmd = "/export/electriccloud/electriccommander/bin/ectool runProcedure @args";
                     debug("> $cmd\n");
                     my $jobnum = `$cmd 2>&1`;

                     if ($jobnum =~ /^\d+$/) {
                        msg("Submitting Build Job: $jobnum\n");
                        map {msg("\t$_\n")} @args;
                        push @pending_changes, @change_list;
                     }
                     else {
                        msg("Error submitting job: $jobnum\n");
                     }
                  }
                  else {
                     msg("Could not find job from Aggregate-Build..\n");
                  }
               }
            }
            # if there are aggregate builds in progress
            elsif (keys(%{$aggregate_build{recommended}})) {
               msg("Waiting for Aggregate-Build to complete (", join(', ', sort(keys(%{$aggregate_build{recommended}}))), ")...\n");
               push @pending_changes, keys(%{$aggregate_build{recommended}});
               next;
            }
            # if there are changes to start aggregate
            elsif (keys(%aggregate_start)) {
               msg("Aggregate Start (", join(', ', sort(keys(%aggregate_start))), ").\n");

               # determine if there are outstanding dependencies not in this aggregation
               foreach my $changeid (sort(keys(%aggregate_start))) {
                  my $change = $aggregate_start{$changeid};
                  my $revision = $change->{revisions}->{$change->{current_revision}};
                  my $revision_num = $revision->{_number};

                  my @dependant_changes;
                  foreach my $parent (@{$revision->{commit}->{parents}}) {
                     # fetch current status of parent from Gerrit
                     my $gerrit_query = "/changes/?q=$parent->{commit}&o=CURRENT_REVISION";
                     debug("Gerrit Query: $gerrit_query\n");
                     my $results = eval { $gerrit->GET($gerrit_query) };
                     debug(Dumper($results));

                     foreach my $parent (@{$results}) {
                        # if parent is a change in aggregation
                        if (defined($aggregate_start{$parent->{_number}}) &&
                           $aggregate_start{$parent->{_number}}->{current_revision} eq $parent->{current_revision}) {
                           next;
                        }
                        elsif ($parent->{status} eq 'MERGED') {
                           next;
                        }
                        else {
                           push @dependant_changes, $parent->{_number};
                        }
                     }
                  }
                  if (@dependant_changes) {
                     # remove this change from the aggregate start and add a comment
                     msg("$changeid: Dependant on (", join(', ', @dependant_changes), ")\n");

                     delete($aggregate_start{$changeid});
                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num","Aggregate build skipped due to missing dependant changes: ".join(', ', @dependant_changes));
                     $aggregate_skip{$changeid} = 1;
                  }
               }
               unless (keys(%aggregate_start)) {
                  msg("No unblocked changes to aggregate.\n");
                  next;
               }
               # don't process changes unless there is a configuration section in the buildlist ini file
               if (defined($config{$delivery})) {
                  my $build_package = $config{$delivery}->{aggregate_package};
                  my $build_list = defined($config{packages}->{$build_package}) ? $config{packages}->{$build_package} : '';

                  debug("Build list = $build_list\n");
                  my @build_list = split(/\s*,\s*/, $build_list);

                  my @submit_builds = ();
                  foreach my $build (@build_list) {
                     # ignore configuration entries
                     next if ($build eq 'config' || $build eq 'builds' || $build eq 'packages' || $build eq 'default');

                     my @dirs;
                     foreach my $sec ('default', $build) {
                        if (defined($config{$sec}->{dirs})) {
                           my $dirs = $config{$sec}->{dirs};
                           $dirs =~ s/\n/;/gs;
                           $dirs =~ s/,/;/gs;

                           push @dirs, grep {$_} split(';', $dirs);
                        }
                     }
                     &debug("Build Dirs: ", join(';', @dirs), "\n");
                     if (@dirs) {
                        # only include build if it matches the files
                        my $include = 0;

                        # iterate over each change
                        foreach my $changeid (sort(keys(%aggregate_start))) {
                           my $change = $aggregate_start{$changeid};
                           my $revision = $change->{revisions}->{$change->{current_revision}};
                           my $revision_num = $revision->{_number};

                           foreach my $dir (@dirs) {
                              my $not = 0;
                              if ($dir =~ /^\!(.*?)$/) {
                                 $not = 1;
                                 $dir = $1;
                              }
                              $dir = "/$dir" unless ($dir =~ /^\//);

                              foreach my $file (keys($revision->{files})) {
                                 $file = "/$file" unless ($file =~ /^\//);
                                 if ($file =~ /^$dir/i) {
                                    if ($not) {
                                       debug("(ignore) !$dir -> $file\n");
                                       $include = 0;
                                    }
                                    else {
                                       debug("(include) $dir -> $file\n");
                                       $include = 1;
                                    }
                                 }
                              }
                              last if ($include);
                           }
                           push @submit_builds, $build if ($include);
                        }
                     }
                     else {
                        push @submit_builds, $build;
                     }
                  }
                  msg("Submit builds: @submit_builds\n");

                  my @change_list;
                  foreach my $changeid (sort(keys(%aggregate_start))) {
                     my $change = $aggregate_start{$changeid};
                     my $revision_num = $change->{revisions}->{$change->{current_revision}}->{_number};

                     push @change_list, "$changeid/$revision_num";
                  }

                  if (@submit_builds) {
                     # Submit Aggregate Build
                     my @args = ("CCX_SOFTWARE");
                     push @args, "--procedureName \"" . (($Bin =~ /\/staging\// || $Bin =~ /_dev\//) ? 'Build (debug)' : 'Build') . "\"";
                     push @args, "--actualParameter \"Site=" . uc($config{$delivery}->{site} || $site) . "\"";
                     push @args, "--actualParameter \"Repo=$project\"";
                     push @args, "--actualParameter \"Branch=$branch\"";
                     push @args, "--actualParameter \"Change=". join(",", @change_list) . "\"";
                     push @args, "--actualParameter \"Type=aggregate\"";
                     my $threads = $config{$delivery}->{build_threads} || 1;
                     push @args, "--actualParameter \"Threads=$threads\"";
                     push @args, "--actualParameter \"Build=" . join("\n", map {"$_;true;"} @submit_builds) . "\"";

                     my $cmd = "/export/electriccloud/electriccommander/bin/ectool runProcedure @args";
                     debug("> $cmd\n");
                     my $jobnum = `$cmd 2>&1`;

                     if ($jobnum =~ /^\d+$/) {
                        msg("Submitting Aggregate Build Job: $jobnum\n");
                        map {msg("\t$_\n")} @args;
                        push @pending_changes, @change_list;

                     }
                     else {
                        msg("Error submitting job: $jobnum\n");
                     }
                  }
                  else {
                     foreach my $change (@change_list) {
                        my ($changeid, $revision_num) = split('/', $change);
                        next unless ($revision_num);
                        &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                        "No aggregate builds to verify.\n",
                                        'Aggregate-Build' => 2,
                                        'Aggregate-Test' => 2,
                                        );
                     }
                  }
               }
               else {
                  foreach my $changeid (sort(keys(%aggregate_start))) {
                     my $change = $aggregate_start{$changeid};
                     my $revision_num = $change->{revisions}->{$change->{current_revision}}->{_number};

                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                     "No delivery configuration on target branch.\n",
                                     'Aggregate-Build' => 2,
                                     'Aggregate-Test' => 2,
                                     );
                  }
               }
            }
         }
         # check to see if we are working on any changes for this project
         if (@pending_changes) {
            msg("Waiting on changes: ".join(', ', sort(@pending_changes)), "\n");
         }
         else {
            msg("Nothing to do for this project.\n");
            push @gerrit_skip_projects, $project;
         }
      }
   }

   if (time() > ($start_time + $window)) {
      msg("Window has expired, exiting...\n");
      exit 0;
   }

   my $poll_time = (time() - $loop_time);
   msg("Took ", dhms($poll_time), "...\n");
   my $sleep_time = $poll_period - (time() - $loop_time);
   msg("Sleeping ", dhms($sleep_time), "...\n");
   sleep $sleep_time;
}
