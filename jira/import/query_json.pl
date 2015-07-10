#!/usr/bin/perl
# usage:
# perl query_json.pl --source file.json ... --query 'array.field' ...
# perl query_json.pl --source sources/14158.json ... --query 'key' --query 'Linked Issues.inwardIssue.key'

use strict;
use Getopt::Long;
use Data::Dumper;
use JSON;
use FindBin qw($Bin $Script);
#use lib "$Bin/lib";

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my @sources = ();
my @queries = ();

my $start = '';
my $max = 0;
my $json = 1;
my $pretty = 1;

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('debug'     => \$debug,
           'source=s'  => \@sources,
           'query=s'   => \@queries,
           'start=s'   => \$start,
           'max=n'     => \$max,
           'json!'     => \$json,
           'pretty'    => \$pretty,
           );

my $usage = "Usage: query_json.pl --source file.json ... --query 'array.field' ...";

unless (@sources) {
   msg("$usage\n\tAt least one source must be specified.\n");
   exit 1;
}

unless (@queries) {
   msg("$usage\n\tAt least one query must be specified.\n");
   exit 1;
}

print "[\n" if ($json);
my $count = 0;
foreach my $source (@sources) {
   msg("Loading source file: $source.\n");
   my $source_text = `cat $source`;
   unless ($source_text) {
      msg("Source file could not be loaded.\n");
      exit 1;
   }
   msg("Decoding source file...\n");
   my $source_records = from_json($source_text);

   foreach my $record (ref($source_records) eq 'ARRAY' ? @{$source_records} : ($source_records)) {
      next if ($start && $start ne $record->{key});
      $start = '';

      my @output;
      my @vals;
      foreach my $query (@queries) {
#         my ($query_key, $query_param) = split('=', $query, 2);
         my @query_array = split (/\//, $query);

         debug("$record->{key}: @query_array\n");

         my $val = fetch_param($record, @query_array);
         next if (ref($val) eq 'ARRAY' && !(@{$val}));
         next if (ref($val) eq 'HASH' && !(keys(%{$val})));

         push @output, %{$val};
         
         unless ($json) {
            push @vals, join(',', (ref($val) eq 'ARRAY') ? @{$val} : ($val));
         }
      }
      my %hash = @output;
      if ($json) {
         next unless (keys(%hash));
         print to_json(\%hash, {pretty => $pretty, canonical => $pretty}), "\n" ;
      }
      else {
         print join('|', @vals),"\n";
      }
      $count++;
      last if ($max && $count >= $max);
   }
   last if ($max && $count >= $max);
}
print "\n]\n" if ($json);

sub fetch_param($@) {
   my ($record, @params) = @_;

   debug(Dumper($record)) if ($max);

   if (defined($record)) {
      if (ref($record) eq 'HASH') {
         my $param_list = shift(@params);
         debug("HASH: ->$param_list (@params)\n");
         my %vals;
         my $use = 1;
         foreach my $param (split(',', $param_list)) {
            my $eq;
            if ($param =~ /^(.*?)=(.*?)$/) {
               $param = $1;
               $eq = $2;
            }
            if (defined($record->{$param})) {
               my $val = fetch_param($record->{$param}, @params);
               if ($eq && $val ne $eq) {
                  $use = 0;
                  last;
               }
               next if (ref($val) eq 'ARRAY' && !(@{$val}));
               next if (ref($val) eq 'HASH' && !(keys(%{$val})));

               $vals{$param} = $val;
            }
         }
         return $use ? \%vals : undef;
      }
      elsif (ref($record) eq 'ARRAY') {
         debug("ARRAY: (@params)\n");
         my @array;
         foreach my $item (@$record) {
            my $val = fetch_param($item, @params);
            if (defined($val)) { 
               next if (ref($val) eq 'HASH' && !(keys(%{$val})));
               push @array, $val;
            }
         }
         return \@array;
      }
      elsif (ref($record) eq '') {
         debug("SCALAR: '$record'\n");
         return $record;
      }
   }
   return undef;
}
