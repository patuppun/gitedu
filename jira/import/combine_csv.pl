#!/usr/bin/perl
# usage:
# perl export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --query 14155 --user cpverne --max 1 --nfeed nfeed_values.csv --file rtpjira_ids.txt
# perl export_jira.pl --server engjira.sj.broadcom.com:8080 --query 21985

use strict;
use Getopt::Long;

$Data::Dumper::Sortkeys = 1;

my $debug = 0;

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('debug'        => \$debug,
           );

my $usage = "Usage: combine_csv.pl <file.csv> ...";

unless (@ARGV) {
   msg("$usage\n\tatleast one file must be specified.\n");
   exit 1;
}

my $header_file;
my $headers;
foreach my $file (@ARGV) {
   if (-e $file) {
      my @contents = `cat $file`;
      my $file_headers = shift(@contents);
      unless ($headers) {
         $headers = $file_headers;
         $header_file = $file;
         print $headers;
      }

      if ($headers && $headers ne $file_headers) {
         msg("Error: Headers differ for between '$file_headers' and '$file'\n");
      }
      print @contents;
   }
}
print "\n";
