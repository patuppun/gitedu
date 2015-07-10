#!/usr/local/bin/perl
use strict;
use FindBin qw($Bin $Script);
use lib "$Bin/../perllib";

use Getopt::Long;
use Data::Dumper;
use JSON;
use Gerrit::REST;

my $tools_dir = "$Bin/..";

my $debug = 0;

my $gerrit_server = 'gerrit-ccxsw.rtp.broadcom.com';

my $project = '';
my $change = '';
my $branch = '';

my $username = '';
my $password = '';
my $site = 'rtp';
my $message = '';
my @labels = ();

# Load commandline options
GetOptions('debug'     => \$debug,

           'project=s'  => \$project,
           'change=s'  => \$change,
           'branch=s'  => \$branch,

           );

my $debug_opt = $debug ? '--debug' : '';

# Sub-routines
sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

sub dhms($) {
   my ($sec) = @_;
   my $min = sprintf($sec / 60);
   $sec %= 60;
   my $hour = int($min / 60);
   $min %= 60;
   my $day = int($hour / 24);
   $hour %= 24;

   $min = "0$min" if ($min < 10);
   $sec = "0$sec" if ($sec < 10);

   my @parts;
   push @parts, "${day}d " if ($day);
   push @parts, "${hour}:${min}:${sec}";
   return join('', @parts);
}

sub remote_file($$$$) {
   my ($site, $repo, $baseline, $file) = @_;
   debug("Fetching $baseline:$file\n");
   $repo =~ s/\s*//g;
   my @data = `ssh svcccxswgit\@git-ccxsw.$site.broadcom.com 'git --git-dir=/home/svcccxswgit/repositories/$repo.git show $baseline:$file' 2>&1`;
   chomp(@data);
   
   my $header = 1;
   my @out_data;
   foreach my $line (@data) {
      next if ($header && $line =~ /^[+|]/);
      $header = 0;
      push @out_data, $line;
   }
   return @out_data;
}

sub parse_inifile(@) {
   my (@lines) = @_;
   my %ini;
   my $section;
   foreach my $line (@lines) {
#      print "$line\n" if ($debug);
      next if ($line =~ /^\s*#/ || $line =~ /^\s*$/);
      if ($line =~ /^(.*?)=(.*?)$/) {
         debug("$section.$1=$2\n");
         $ini{$section}->{$1} = defined($ini{$section}->{$1}) ? "$ini{$section}->{$1}\n$2" : $2;
      }
      if ($line =~ /^\s*\[(.*?)\]\s*$/) {
         $section = $1;
         $ini{$section} ||= {};
      }
   }
   return %ini;
}

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

my @changes = split(/,\s*/, $change);
my @changes_merged = ();

foreach my $change (@changes) {
   my ($changeid, $revision_num) = split('/', $change);
   my $rc = eval {$gerrit->POST("/changes/$changeid/revisions/$revision_num/submit",         
                                {wait_for_merge => "true",
                                }
                               )
                  };
   if ($@) {
      msg("$changeid/$revision_num: Error: $@->{content}\n");

      my $label = 'Aggregate-Test';
      my $label_val = +1;
      my $message = "Error submitting change for merge:\t$@->{content}\n";

      system("$tools_dir/gerrit/gerrit_notify.pl $debug_opt --change $changeid/$revision_num --message \"$message\" --label \"$label=$label_val\"");
      next;
   }
   msg("$changeid/$revision_num: Submission Status = $rc->{status}\n");

   push @changes_merged, $change;
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

   if (defined($config{delivery})) {
      my $build_package = $config{delivery}->{delivery_builds};

      if ($build_package) {
         my @args = ("CCX_SOFTWARE");
         push @args, "--procedureName \"" . ($debug ? 'Build (debug)' : 'Build') . "\"";
         push @args, "--actualParameter \"Site=" . ($config{delivery}->{site} || $site) . "\"";
         push @args, "--actualParameter \"Repo=$project\"";
         push @args, "--actualParameter \"Branch=$branch\"";
         push @args, "--actualParameter \"AutoTag=Y\"";
         push @args, "--actualParameter \"Type=build\"";
         push @args, "--actualParameter \"Package=$build_package\"";

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

               system("$tools_dir/gerrit/gerrit_notify.pl $debug_opt --change $changeid/$revision_num --message \"$message\"");
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
