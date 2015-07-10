#!/usr/bin/perl
# usage:
# perl combine_json.pl <input file 1.json> <input file 2.json> ... > output.json
# perl 

use strict;
use Getopt::Long;
use JSON;

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my $pretty = 0;

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('debug'        => \$debug,
           'pretty'       => \$pretty,
           );

my $usage = "Usage: combine_json.pl [--debug] [--pretty] <file.json> ...";

unless (@ARGV) {
   msg("$usage\n\tatleast one file must be specified.\n");
   exit 1;
}

my @array;
my %hash;

foreach my $file (@ARGV) {
   msg("Loading JSON file: $file.\n");
   my $source_text = `cat $file`;
   unless ($source_text) {
      msg("JSON file could not be loaded.\n");
      exit 1;
   }
   msg("Decoding JSON file...\n");
   my $data = from_json($source_text);
   if (ref($data) eq 'ARRAY') {
      push @array, @{$data};
      msg(scalar(@{$data}), " entries.\n");
   }
   elsif (ref($data) eq 'HASH') {
      debug("merge HASH\n");
      merge_hash(\%hash, $data);
   }
   else {
      push @array, $data;
   }
}

if (@array) {
   print to_json(\@array);
}
else {
   print to_json(\%hash, {pretty => $pretty, canonical => $pretty});
}

sub merge_hash($$) {
   my ($dest, $new) = @_;

   foreach my $key (keys(%{$new})) {
      debug("merge HASH.$key\n");

      if (defined($dest->{$key})) {
         if (ref($dest->{$key}) eq 'HASH') {
            debug("merge HASH\n");
            merge_hash($dest->{$key}, $new->{$key});
         }
         elsif (ref($dest->{$key}) eq 'ARRAY') {
            debug("merge ARRAY\n");
            push @{$dest->{$key}}, @{$new->{$key}};
         }
      }
      else {
         $dest->{$key} = $new->{$key};
      }
   }
}
