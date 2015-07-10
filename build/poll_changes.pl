#!/usr/local/bin/perl
use strict;
use FindBin qw($Bin $Script);
use lib "$Bin/../perllib";

use Getopt::Long;
use Data::Dumper;
use JSON;
use Gerrit::REST;
use Time::Local;

my $tools_dir = "$Bin/..";

require "$tools_dir/perllib/delivery.pm";

my $debug = 0;
my $poll_period = 60;
my $window = '4,8,12,16,20,24';

my $gerrit_server = 'gerrit-ccxsw.rtp.broadcom.com';
my $gerrit_project = '';
my $gerrit_skip_project = '';
my $gerrit_branch = '';

my $username = '';
my $password = '';
my $site = 'rtp';

# Load commandline options
GetOptions('debug'     => \$debug,
           'poll=n'    => \$poll_period,
           'window=s'  => \$window,
           'gerrit=s'  => \$gerrit_server,
           'project=s' => \$gerrit_project,
           'noproject=s' => \$gerrit_skip_project,
           'branch=s'  => \$gerrit_branch,
           );

sub debug(@) { msg(@_) if ($debug) }
my $debug_opt = $debug ? '--debug' : '';

my @gerrit_projects = split(',', $gerrit_project);
my @gerrit_skip_projects = split(',', $gerrit_skip_project);

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

# determine next window start
my ($sec, $min, $hour, $day, $month, $year) = localtime($start_time); 

my $end_time = $start_time + (1*60*60);
my $day_start = timelocal(0,0,0,$day,$month,$year); 

my $window_hour = 0;
while ($window_hour <= 24) {
   my $window_start = $day_start + ($window_hour * 60 * 60);
   if ($window_start && (($window_start - $poll_period) > $start_time)) {
      $end_time = $window_start - $poll_period;
      last;
   }
   $window_hour += $window;
}

# Loop until window is exausted
msg("Starting.. (", scalar(localtime($start_time)), " - ", scalar(localtime($end_time)), ")\n");
while ($end_time && $end_time > time()) {
   my $loop_time = time();
   my $rc = 0;
   # connect to gerrit server and fetch changes
   msg("Fetching changes from Gerrit..\n");
   my $project_opt = join('+OR+', map {"project:$_"} @gerrit_projects);
   $project_opt = (@gerrit_projects > 1) ? "+($project_opt)" : "+$project_opt";
   my $noproject_opt = join('', map {"+-project:$_"} @gerrit_skip_projects);
   my $branch_opt = $gerrit_branch ? "+branch:$gerrit_branch" : '';
   my $gerrit_query = "/changes/?q=status:open$project_opt$noproject_opt$branch_opt";
   my $changes = eval { $gerrit->GET($gerrit_query) };
   debug("Gerrit Query: $gerrit_query\n");
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

      # Iterate through each project returned
      foreach my $project (sort(keys(%projects))) {
         msg("Project: $project..\n");
         # load the project's configuration
         my @project_config = &remote_file($site, $project, 'refs/meta/config', 'project.config');
         my %project_config = &parse_inifile(@project_config);

         unless (defined($project_config{"label \"Build-Verification\""})) {
            msg("\tNot configured for Continuous Delivery, skipping..\n");
            next;
         }

         foreach my $branch (sort(keys(%{$projects{$project}}))) {
            msg("$project->$branch..\n");

            foreach my $changeid (sort(keys(%{$projects{$project}->{$branch}}))) {
               my $gerrit_query = "/changes/$changeid/detail?o=DETAILED_LABELS&o=DETAILED_ACCOUNTS&o=MESSAGES&o=CURRENT_REVISION&o=CURRENT_FILES";
               debug("Gerrit Query: $gerrit_query\n");
               my $change = eval { $gerrit->GET($gerrit_query) };
               debug(Dumper($change));

               my $revision = $change->{revisions}->{$change->{current_revision}};
               my $revision_num = $revision->{_number};
               my %config;
               my $delivery;

               msg("Processing change $project->$branch->$changeid/$revision_num..\n");

               debug("Change Labels: ", Dumper($change->{labels}));
               # only if builds are needed
               my $merge_label = $change->{labels}->{'Merge'} || {};
               if (&label_status($change, 'Merge', 1) || 
                   &label_status($change, 'Merge', -1)) {   
                  msg("No build verification required..\n");
                  next;
               }

               # Verify Build-Verification
               if (&label_status($change, 'Build-Verification', 2)) {
                  msg("Build Verification completed successfully..\n");
               }
               elsif (&label_status($change, 'Build-Verification', 1)) {
                  msg("Build Verification in progress..\n");
                  next;
               }
               elsif (&label_status($change, 'Build-Verification', -1)) {
                  msg("Build Verification failed..\n");
                  next;
               }
               else {
                  # Need to submit Build-Verification job
                  # load the configuration from the change branch
                  my @buildlist = &remote_file($site, $project, change_ref($changeid, $revision_num), 'buildlist.ini');
                  %config = &parse_inifile(@buildlist);
                  $delivery = &delivery_section($branch,\%config);

                  # don't process change unless there is a configuration section in the buildlist ini file
                  unless ($delivery && defined($config{$delivery})) {
                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                     "Delivery not supported for this change.\n",
                                     'Merge' => -1,
                                     );
                     next;
                  }

                  # determine build list
                  my $build_package = $config{$delivery}->{change_package};
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
                     else {
                        push @submit_builds, $build;
                     }
                  }
                  msg("Submit builds: @submit_builds\n");

                  if (@build_list == 0) {
                     msg("No builds configured.\n");
                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                     "No builds configured.\n",
                                     'Build-Verification' => 2,
                                     'Static-Analysis' => 2,
                                     'Test-Verification' => 2,
                                     );
                     next;
                  }
                  elsif (@build_list >= 0 && @submit_builds == 0) {
                     &gerrit_message($tools_dir, $debug, "$changeid/$revision_num",
                                     "No builds applicable for this change.\n",
                                     'Build-Verification' => 2,
                                     'Build-Verification' => 2,
                                     'Test-Verification' => 2,
                                     );
                     next;
                  }
                  else {
                     my @args = ("CCX_SOFTWARE");
                     push @args, "--procedureName \"" . (($Bin =~ /\/staging\// || $Bin =~ /_dev\//) ? 'Build (debug)' : 'Build') . "\"";
                     push @args, "--actualParameter \"Site=" . uc($config{$delivery}->{site} || $site) . "\"";
                     push @args, "--actualParameter \"Repo=$project\"";
                     push @args, "--actualParameter \"Branch=$branch\"";
                     push @args, "--actualParameter \"Change=$changeid/$revision_num\"";
                     push @args, "--actualParameter \"Coverity=partial\"";
                     push @args, "--actualParameter \"Type=change\"";
                     my $threads = $config{$delivery}->{build_threads} || 1;
                     push @args, "--actualParameter \"Threads=$threads\"";
                     push @args, "--actualParameter \"Build=" . join("\n", map {"$_;true;"} @submit_builds) . "\"";

                     my $cmd = "/export/electriccloud/electriccommander/bin/ectool runProcedure @args";
                     debug("> $cmd\n");
                     my $jobnum = `$cmd 2>&1`;

                     if ($jobnum =~ /^\d+$/) {
                        msg("Build job submitted: $jobnum -> Build=", join(', ', @submit_builds), "\n");
                     }
                     else {
                        msg("Error submitting job: $jobnum\n");
                     }
                     next;
                  }
               }

               # Test-Verification
               # if builds are completed, go on to change branch testing
               if (&label_status($change, 'Build-Verification', 2)) {
                  if (&label_status($change, 'Test-Verification', 2)) {
                     msg("Test Verification completed successfully..\n");
                  }
                  elsif (&label_status($change, 'Test-Verification', 1)) {
                     msg("Test Verification in progress..\n");
                  }
                  elsif (&label_status($change, 'Test-Verification', -1)) {
                     msg("Test Verification failed..\n");
                  }
                  else {
                     # load the configuration from the change branch
                     unless (%config) {
                        my @buildlist = &remote_file($site, $project, change_ref($changeid, $revision_num), 'buildlist.ini');
                        %config = &parse_inifile(@buildlist);
                        $delivery = &delivery_section($branch,\%config);
                     }

                     # determine the last build submitted to get Build-Verification+2;
                     msg("Determine job for Test Verification..\n");

                     my $build_job = '';
                     foreach my $message (@{$change->{messages}}) {
                        next unless ($message->{_revision_number} == $revision_num);
                        next unless ($message->{author}->{username} eq 'ccxswbuild');

                        if ($message->{message} =~ /Build-Verification\+2/s &&
                            $message->{message} =~ /jobs\/(.*?)\n/s) {
                           $build_job = $1;
                        }
                     }

                     if ($build_job) {
                        my @args = ("CCX_SOFTWARE");
                        push @args, "--procedureName \"" . (($Bin =~ /\/staging\// || $Bin =~ /_dev\//) ? 'Test (debug)' : 'Test') . "\"";
                        push @args, "--actualParameter \"Site=" . uc($config{$delivery}->{site} || $site) . "\"";
                        push @args, "--actualParameter \"Repo=$project\"";
                        push @args, "--actualParameter \"Branch=$branch\"";
                        push @args, "--actualParameter \"Change=$changeid/$revision_num\"";
                        push @args, "--actualParameter \"Type=change\"";
                        push @args, "--actualParameter \"BuildJob=$build_job\"";

                        my $cmd = "/export/electriccloud/electriccommander/bin/ectool runProcedure @args";
                        debug("> $cmd\n");
                        my $jobnum = `$cmd 2>&1`;

                        if ($jobnum =~ /^\d+$/) {
                           msg("Build job submitted: $jobnum -> BuildJob=$build_job\n");
                        }
                        else {
                           msg("Error submitting job: $jobnum\n");
                        }
                        next;
                     }
                     else {
                        msg("Could not find job from Build Verification..\n");
                     }
                  }
               }
            }
         }
      }
   }

   if ($end_time && ($end_time < time())) {
      msg("Window has expired, exiting...\n");
      exit 0;
   }

   my $poll_time = (time() - $loop_time);
   msg("Took ", dhms($poll_time), "...\n");
   my $sleep_time = $poll_period - (time() - $loop_time);

   if ($sleep_time > 0) {
      msg("Sleeping ", dhms($sleep_time), "...\n");
      sleep $sleep_time;
   }
}


