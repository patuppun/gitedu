#!perl
# usage:
# perl create_project.pl --source ctrl=ctrl.json --project Controller --key CTRL
# perl create_project.pl --source rtpjira=wlan.json --project WLAN --key WLAN
# perl create_project.pl --source engjira=avb_engjira.json --project AVB --key AVB

use strict;
use FindBin qw($Bin $Script);

use lib "$Bin/../../perllib";

use Getopt::Long;
use Data::Dumper;
use Config::IniFiles;
use Spreadsheet::ParseExcel;
use Spreadsheet::XLSX;

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my @files = ();
my @sheets = ('2-Sorted');

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('debug'     => \$debug,
           'file=s'    => \@files,
           'sheet=s'   => \@sheets,
           );

my $usage = "Usage: extract_mapping.pl --file <file name> ... --sheet <sheet name> ... [--debug]";

unless (@files) {
   msg("$usage\n\tAt least one file must be specified.\n");
   exit 1;
}

unless (@sheets) {
   msg("$usage\n\tAt least one sheet must be specified.\n");
   exit 1;
}

my %sheets = map {$_ => 1} @sheets;


my %field_def;
my $fields_file = "$Bin/field_defs.ini";
if (-e $fields_file) {
   tie %field_def, 'Config::IniFiles', ( -file => $fields_file );
   if (@Config::IniFiles::errors) {
      msg(@Config::IniFiles::errors, "\n");
      exit 1;
   }
}
else {
   print "Could not find field definition file: field_defs.ini\n";
   exit;
}

my %mapped_columns;
my %mappings;

foreach my $file (@files) {
   msg("Loading $file...\n");

   my $excel = ($file =~ /\.xlsx$/) ? Spreadsheet::XLSX -> new ($file) : Spreadsheet::ParseExcel -> new () -> parse($file);

   msg("$file loaded\n");
   foreach my $sheet (@{$excel -> {Worksheet}}) {
      next unless (defined($sheets{$sheet->{Name}}));
 
      msg("Sheet: ", $sheet->{Name}, "\n");
      
      $sheet -> {MaxCol} ||= $sheet -> {MinCol};
      $sheet -> {MaxRow} ||= $sheet -> {MinRow};
      
      my @columns;

      foreach my $num ($sheet -> {MinCol} ..  $sheet -> {MaxCol}) {
         my $column_name = &val($sheet -> {Cells} [0] [$num]->{Val});
         next if ($column_name =~ /^\s*$/ || $column_name =~ /^_/);
         push @columns, "$column_name.$num";
      }

      msg("Columns: ", (map {"'$_', "} @columns), "\n");

      for(my $col = 0; $col <= $#columns; $col+=2) {
         next unless $columns[$col];

         my $source = $columns[$col];
         my ($source_column, $source_col) = split(/\./, $source);

         my $dest = $columns[$col+1];
         my ($dest_column, $dest_col) = split(/\./, $dest);

         msg("\t$source_column($source_col) -> $dest_column($dest_col)\n");
         unless (defined($field_def{Fields}{$dest_column})) {
            msg("ERROR: Unknown destination field...\n");
            exit 1;
         }

         $mapped_columns{$dest_column} = 1;
         $mappings{$dest_column} ||= {};

         foreach my $row ($sheet->{MinRow}+1 .. $sheet->{MaxRow}) {
 
            my $source = $sheet -> {Cells} [$row] [$source_col];
            my $dest = $sheet -> {Cells} [$row] [$dest_col];

            my $source_val = &val($source->{Val});
            my $dest_val = &val($dest->{Val});

            # stop going down the column if blank
            next unless ($source_val ne '' && $dest_val ne '');

            debug("$source_column.$source_val = $dest_column.$dest_val\n");

            $mappings{$dest_column}{$source_val} = $dest_val;
         }
      }
   }
}

print "[MappedFields]\n";
print map {"$_=\n"} sort(keys(%mapped_columns));
print "\n";
print "[Values]\n";

foreach my $field (sort(keys(%mapped_columns))) {
   print map {"$field.$_=$mappings{$field}{$_}\n"} sort(keys(%{$mappings{$field}}));
   print "\n";
}


sub val($) {
   my ($val) = @_;
   $val =~ s/^\s+//;
   $val =~ s/\s+$//;

   $val =~ s/\s+\(\d+?\)//;

   # escape endlines
   $val =~ s/\s*\n/\\n/gs;

   # convert = to _
   $val =~ s/=/_/gs;

   # convert &amp; to &
   $val =~ s/&amp;/&/gs;

   # convert '  ' to ' '
   $val =~ s/\s+/ /gs;

   $val = "NOT_IMPORTED" if (lc($val) eq 'not_imported' || lc($val) eq 'not imported');

   return $val;
}
