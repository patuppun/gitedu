#!/usr/local/bin/perl
use strict;
use FindBin qw($Bin $Script);
use lib "$Bin/../perllib";
use File::Path;

use Getopt::Long;
use Data::Dumper;

my $tools_dir = "$Bin/..";

my $debug = 0;
my $test = 0;

my $deliverables_dir = '/projects/ccxsw_tools/deliverables';
my $branch_age = 15;
my $daily_label_age = 15;

# Load commandline options
GetOptions('debug'     => \$debug,
           'test'      => \$test,
           );

my $debug_opt = $debug ? '--debug' : '';

# Sub-routines
sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

my $count = 0;
my $remove = 0;
my $skip = 0;
if (opendir(PROJECT, $deliverables_dir)) {
   foreach my $project (readdir(PROJECT)) {
      next if ($project =~ /^\./);
      next if ($project eq 'bpetry-aruba-drops');

      if (opendir(BUILD, "$deliverables_dir/$project")) {
         foreach my $build (readdir(BUILD)) {
            next if ($build =~ /^\./);
            $count++;
            my $build_age = (-C "$deliverables_dir/$project/$build");
            if ($build eq lc($build) && $build_age > $branch_age) {
               print "$deliverables_dir/$project/$build -> branch ($build_age > $branch_age)\n";
               rmtree("$deliverables_dir/$project/$build", 0, 1);
               $remove++;
            }
            elsif ($build =~ /^\d*_.*\d{8}_\d*$/ && $build_age > $daily_label_age) {
               print "$deliverables_dir/$project/$build -> daily label ($build_age > $daily_label_age)\n";
               rmtree("$deliverables_dir/$project/$build", 0, 1);
               $remove++;
            }
            else {
               print "$deliverables_dir/$project/$build -> skip ($build_age)\n";
               $skip++;
            }
         }
      }
   }
}
print "Skip:\t$skip\n";
print "Remove:\t$remove\n";
print "Total:\t$count\n";
