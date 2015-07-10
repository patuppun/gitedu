#!perl
# usage:
# perl extract_text.pl --file <file> --loc <index> --pad <padding>

use strict;
use Getopt::Long;
use Data::Dumper;

my $file = '';
my $loc = '';
my $pad = '';
my $debug = 0;

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('file=s'  => \$file,
           'loc=n'   => \$loc,
           'pad=n'   => \$pad,
           );

if ($file && -e $file) {
   my $text = `cat $file`;

   my $str = substr($text, $loc-$pad, $pad*2);
   print Dumper(\$str);
}

