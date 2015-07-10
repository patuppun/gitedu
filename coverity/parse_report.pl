#!/usr/local/bin/perl

#Usage: 
#parse_report.pl [options] <file>
#

use Getopt::Long;
use JSON;
use Data::Dumper;

my $help = 0;
my $debug = 0;

GetOptions('help|?' => \$help,
           'debug' => \$debug,
           );

my $file = shift(@ARGV);

if ($help || !$file) {
   print STDERR "Usage: $0 [options] <file>\n";
   exit 1;
}

unless (open(FILE, "<$file")) {
   print STDERR "Error: Could not open file '$file'\n";
   exit 1;
}

my @lines = <FILE>;
close(FILE);

my $text = join("\n", @lines);

my $tree = from_json($text);

print Dumper($tree) if ($debug);

if (defined($tree->{issueInfo})) {
   print "cid,checker,subcategory,description,function,file,line_no\n";
   foreach my $issue (@{$tree->{issueInfo}}) {
      my $cid = $issue->{cid};
      foreach my $occurrence (@{$issue->{occurrences}}) {
         my @params = ($cid,map {$occurrence->{$_}} qw(checker subcategory mainEventDescription function mainEventLineNumber));
         map {$_ =~ s/\"/\"\"/g} @params;
         @params = map {$_ =~ /[," ]/ ? "\"$_\"" : $_} @params;
         print join(',', @params), "\n";
      }
   }
}
