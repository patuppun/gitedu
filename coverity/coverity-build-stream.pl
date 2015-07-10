#!/usr/bin/perl
#
# coverity-build.pl
#
# This script outlines the Coverity build, analyze and commit process.
#
# Usage:
#
# coverity-build.pl [options] <build command>

use strict;
use Cwd;
use FindBin qw($Bin $Script);
use XML::Simple;
use Data::Dumper;

my $rc = 0;

#
# Handle command line
#

use Getopt::Long;
my $test = 0;      # don't actually perform any analysis, used for testing configuration
my $emit = 0;      # submit defects to coverity server

my $version = '';      # label of build when emitting
my $target = '';       # target of build when emitting
my $description = '';  # description of build when emitting

my $output = '.';  # directory to store files in
my $project = '';
my $stream = '';
my $config = '';
my $job_slots = 1;
my $debug = 0;
my $emacs = 0;
my $continue = 0;
my $threads = 1;
my $report_output = '';
my @scan_paths = ();

print "$0 ", join(' ', @ARGV), "\n";
# pass_through: ignore unknown arguments and leave them in @ARGV
Getopt::Long::Configure('bundling', 'pass_through');

GetOptions('test' => \$test,
           'emit' => \$emit,
           'version=s' => \$version,
           'target=s' => \$target,
           'project=s' => \$project,
           'stream=s' => \$stream,
           'config=s' => \$config,
           'output=s' => \$output,
           'threads=n' => \$threads,
           'debug!' => \$debug,
           'emacs!' => \$emacs,
           'continue!' => \$continue,
           'report-output=s' => \$report_output,
           'scan-path=s' => \@scan_paths,
           );

# Check syntax
unless (scalar(@ARGV))
{
   print "Usage: $0 [options] <build command>\n";
   exit 1;
}

print "Project: $project\n";
                            
# Prevent installation directory
my $prevent_ver = $ENV{COVERITYVER} || '7.0';

my $PREVENT_DIR = "/tools/coverity/prevent/$prevent_ver/Linux";
$PREVENT_DIR .= '-64' if (`uname -a` =~ /x86_64/);

my $PREVENT_CONFIG = "--config ". ($config || "$Bin/config/$prevent_ver/coverity.xml");

$ENV{PATH} .= ":$PREVENT_DIR/bin";

# Used by Coverity Commands
my $PREVENT_CFG = "$ENV{HOME}/coverity.xml";

# Used by Coverity Scripts
my $COVERITY_CFG = "$ENV{HOME}/coverity-cov-rtp-03.xml";

#
# Main script
#

# Perform the Coverity-instrumented build
print "\nPerforming Coverity build ...\n";
my $BUILD_PATH = "$output/cvbuild";

unless ($continue) {
   if (-e $BUILD_PATH) {
      &run("rm -rf $BUILD_PATH");
   }
}

# What build options to use
my $BUILD_FILE="$Bin/build_opt.conf";
my $build_opts = '';
if (open(FILE, "<$BUILD_FILE")) {
   my @options;
   foreach my $line (<FILE>) {
      chomp($line);
      next if ($line =~ /^\#/);
      push @options, $line;
   }
   $build_opts = join(' ', @options);
}

if (-e $BUILD_PATH) {
   print "Build already completed.\n";
} else {
   print "\nBuilding package ...\n";
   &run("mkdir -p $BUILD_PATH");
   my $cmd = join(' ', map {$_ =~ / / ? "\"$_\"" : $_} @ARGV);
   &run_cmd(1, "ERROR: build failed, please check $output/build-log.txt for more information\n",
            "$PREVENT_DIR/bin/cov-build $PREVENT_CONFIG --emit-parse-errors --dir $BUILD_PATH $build_opts $cmd");
}

# check build metrics to determine if there were any successfully emited files
if (-e "$BUILD_PATH/BUILD.metrics.xml") {
   my $xml = XMLin("$BUILD_PATH/BUILD.metrics.xml");
   print Dumper($xml) if ($debug);
   
   unless ($xml->{metrics}->{metric}->{successes}->{value}) {
      print "Analysis did not run against any files..\n";
      exit;
   }
}

if (-e "$BUILD_PATH/c/output/analysis-log.txt.gz") {
   print "Analysis already completed.\n";
} else {
   # Where to store derived models from this analysis
   my $DERIVED_MODEL_ROOT="/projects/ccxsw_tools/coverity/derived_models/$prevent_ver";

   # Where user-generated models are stored
   my $MODEL_DIR="/projects/ccxsw_tools/contrib/coverity/user_models/$prevent_ver/$project";
   my $MODEL_DIR_OUTPUT="/projects/ccxsw_tools/coverity/user_models/$prevent_ver/$project";

   my $MODELS = "";

   # What checker options to use
   my $ANALYSIS_FILE="$Bin/analysis_opt.conf";
   my $analysis_opts = '';
   if (open(FILE, "<$ANALYSIS_FILE")) {
      my @options;
      foreach my $line (<FILE>) {
         chomp($line);
         next if ($line =~ /^\#/);
         push @options, $line;
      }
      $analysis_opts = join(' ', @options);
   }

   print "\nCreating stream if needed...\n";
   &run("perl $Bin/create-stream.pl --config \"$COVERITY_CFG\" --project \"$project\" --stream \"$stream\"");

   if ($emit) {
      print "Checking for user models: $MODEL_DIR\n";
      if (-d $MODEL_DIR) {
         print "\nCompiling user models for $project ...\n";
         my @model_source = `ls -1 $MODEL_DIR/*.c`;
         chomp(@model_source);

         &run("mkdir -p \"$MODEL_DIR_OUTPUT\"");
         &run("$PREVENT_DIR/bin/cov-make-library $PREVENT_CONFIG --output-file \"$MODEL_DIR_OUTPUT/$stream.xmldb\" @model_source");
      
         if ( $? > 0 ){
            print "ERROR: user_models build failed, please check output for more information\n";
            exit 1;
         }

         $MODELS = "--user-model-file \"$MODEL_DIR_OUTPUT/$stream.xmldb\"";
      }

      # Perform analysis
      print "\nPerforming analysis...\n";
      print "ANALYSIS_OPTS=$analysis_opts\n\n";
      my $max_mem = "--max-mem 4096";
      &run_cmd(2, "ERROR: Error while analyzing build, please check output for more information\n",
               "$PREVENT_DIR/bin/cov-analyze $PREVENT_CONFIG --dir $BUILD_PATH --strip-path \"$output\" $max_mem $analysis_opts $MODELS");

      # Save derived models for desktop analysis
      if (-d $DERIVED_MODEL_ROOT) {
         print "\nSaving derived models for desktop analysis ...\n";
         &run("mkdir -p $DERIVED_MODEL_ROOT/$project") unless (-d "$DERIVED_MODEL_ROOT/$project");
         &run("$PREVENT_DIR/bin/cov-collect-models $PREVENT_CONFIG --dir $BUILD_PATH --output-file \"$DERIVED_MODEL_ROOT/$project/$stream.xmldb.tmp\"");
         &run("mv -u \"$DERIVED_MODEL_ROOT/$project/$stream.xmldb.tmp\" \"$DERIVED_MODEL_ROOT/$project/$stream.xmldb\"");
      }
   
      # Generate commit report
      print "\nGenerating Commit Report ...\n";
      my $description_opt = $description ? "--description \"$description\"" : '';
      my $version_opt = $version ? "--version \"$version\"" : '';
      my $target_opt = $target ? "--target \"$target\"" : '';

      &run_cmd(3, "ERROR: Error while generating report, please check output for more information\n",
               "$PREVENT_DIR/bin/cov-commit-defects --config $PREVENT_CFG --dir $BUILD_PATH --stream \"$stream\" --preview-report \"$BUILD_PATH/scan-report.json\" --ticker-mode no-spin");

      # Commit results to Defect Manager
      print "\nCommitting results to Defect Manager ...\n";
      my $description_opt = $description ? "--description \"$description\"" : '';
      my $version_opt = $version ? "--version \"$version\"" : '';
      my $target_opt = $target ? "--target \"$target\"" : '';

      &run_cmd(3, "ERROR: Error while committing defects, please check output for more information\n", 
               "$PREVENT_DIR/bin/cov-commit-defects --config $PREVENT_CFG --dir $BUILD_PATH --stream \"$stream\" $description_opt $version_opt $target_opt --ticker-mode no-spin");

   } else {
      # Perform analysis
      print "\nPerforming desktop analysis...\n";

      if ($project) {
         my @models = map {"--user-model-file \"$_\""} glob("$MODEL_DIR_OUTPUT/$project/*.xmldb");

         push @models, map {"--derived-model-file \"$_\""} glob("$DERIVED_MODEL_ROOT/$project/*.xmldb");
         $MODELS = "@models";
      }
#      my $restrict_opt = "--restrict-modified-file-regex ". join('|', @scan_paths);
#      my $output_opt = "--json-output $report_output/scan-report.json"
#
#      print "\nChecker Options: $analysis_opts\n\n";
#      &run_cmd(1, "ERROR: Error while analyzing build, please check output for more information\n",
#               "$PREVENT_DIR/bin/cov-run-desktop $PREVENT_CONFIG --dir $BUILD_PATH --strip-path \"$output\" $analysis_opts $MODELS $output_opt $restrict_opt");

      &run_cmd(1, "ERROR: Error while analyzing build, please check output for more information\n",
               "$PREVENT_DIR/bin/cov-analyze $PREVENT_CONFIG --dir $BUILD_PATH --strip-path \"$output\" $analysis_opts $MODELS");
 
      $report_output ||= $BUILD_PATH;
      print "\nGenerating defect reports...\n";
      # Generate defect reports
      &run("$PREVENT_DIR/bin/cov-format-errors $PREVENT_CONFIG --dir $BUILD_PATH -x --filesort --html-output \"$report_output/html\"");
      &run("$PREVENT_DIR/bin/cov-format-errors $PREVENT_CONFIG --dir $BUILD_PATH -x --filesort --emacs-style --html-output \"$report_output/html\"") if ($emacs);

      # Generate commit report
      print "\nGenerating Commit Report ...\n";
      my $description_opt = $description ? "--description \"$description\"" : '';
      my $version_opt = $version ? "--version \"$version\"" : '';
      my $target_opt = $target ? "--target \"$target\"" : '';

      &run_cmd(3, "ERROR: Error while generating report, please check output for more information\n",
               "$PREVENT_DIR/bin/cov-commit-defects --config $PREVENT_CFG --dir $BUILD_PATH --stream \"$stream\" --preview-report \"$report_output/scan-report.json\" --ticker-mode no-spin");

      print "\n\nCoverity build and analysis for $project complete\n\nPlease see $report_output/html/index.html for results\n" unless ($emacs);

   }
}

exit $rc;


sub run_cmd($$$) {
   my ($count, $msg, @cmd) = @_;

   while ($count) {
      print "TEST " if ($test);
      print "RUN($count): ", (map {"'$_'"} @cmd), "\n";
      $count--;
      if ($test) {
         return 0;
      }
      else {
         my $start_time = time();
         system(@cmd);
         sleep(1);  # wait for everything to print out before printing the message and exiting.
         print "RUN DURATION($count): ", &dhms(time() - $start_time), "\n";

         if ($? > 0) {
            print $msg;
            unless ($count) {
               $rc = 1;
               $test = 1;  # turn on test mode to print out remaining commands, but don't do anything
            }
            print "$count more attempts.\n";
         }
         else {
            last;
         }
      }
   }
}

sub run(@) {
   print "TEST " if ($test);
   print "RUN: ", join(' ', @_), "\n";

   return 0 if ($test);
   return system(@_);
}

sub dhms($) {
   my ($sec,$fmt) = @_;
   $fmt ||= "dhms";

   my $day = int($sec / (24*60*60));
   $sec -= $day * (24*60*60);

   my $hour = int($sec / (60*60));
   $sec -= $hour * (60*60);

   my $min = int($sec / (60));
   $sec -= $min * (60);

   my @times;
   if ($fmt eq 'dhms') {
      push @times, "${day}d " if ($day);
      push @times, "${hour}h " if ($hour);
      push @times, "${min}m " if ($min);
      push @times, "${sec}s" if ($sec || scalar(@times) == 0);
   }
   elsif ($fmt eq ':') {
      push @times, sprintf("%02d:", $day) if ($day);
      push @times, sprintf("%02d:", $hour) if ($day || $hour);
      push @times, sprintf("%02d:%02d", $min, $sec);
      $times[0] =~ s/^0(\d)/$1/;
   }
   return join('', @times);
}

