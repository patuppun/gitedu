use strict;
use Getopt::Long;
use Data::Dumper;
use JSON;
use FindBin qw($Bin $Script);
use DBI qw(:sql_types);

$Data::Dumper::Sortkeys = 1;

use lib "$Bin/../perllib";
use DB::NFEED;

my $debug = '';
my $test = 0;

my $server = 'mysql-rtp-02.rtp.broadcom.com:3306';
my $db = 'CCXSW_JIRA_nFeed';
my $username = '';
my $password = '';

my $table = '';

my $dump = 0;
my $schema = 0;

my $delete = 0;
my $query = 0;

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('debug'     => \$debug,
           'test'      => \$test,
           'server=s'  => \$server,
           'db=s'      => \$db,
           'user=s'    => \$username,
           'pass=s'    => \$password,
           'dump'      => \$dump,
           'table=s'   => \$table,

           'delete'    => \$delete,
           'query'     => \$query,
           );

if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
  foreach my $line (<NETRC>) {
    chomp($line);
    if ($line =~ /^machine $server\/$db login (.*?) password (.*?)$/) {
      $username = $1;
      $password = $2;
      last;
    }
  }
}

unless ($username) {
   print "No username selected.\n";
   exit 1;
}

my $db = DB::NFEED->new(server => $server,
                        database => $db,
                        username => $username,
                        password => $password,
                        debug => $debug,
                        test => $test);

unless ($db) {
   exit;
}

my $nfeed_schema = $db->GetParam('schema');

my %params;
foreach my $val (@ARGV) {
   if ($val =~ /^(.*?)=(.*?)$/) {
      $params{$1} = $2;
   }
}

if ($schema) {
   print join(',', keys(%{$nfeed_schema})), "\n";
}
elsif ($dump) {
   foreach my $nfeed_schema_table (sort(keys(%{$nfeed_schema}))) {
      next if ($table && ($table ne $nfeed_schema_table));

      my @results = $db->Query($nfeed_schema_table, %params);

      print "/* $table */\n";
      my $columns = join(",", @{$nfeed_schema->{$nfeed_schema_table}->{columns}});

      foreach my $row (@results) {
         print "INSERT IGNORE INTO $nfeed_schema_table ($columns) VALUES (", join(',', map {"\"$row->{$_}\""} @{$nfeed_schema->{$nfeed_schema_table}->{columns}}), ");\n";
      }
      print "\n";
   }
}
elsif ($query) {
   foreach my $nfeed_schema_table (sort(keys(%{$nfeed_schema}))) {
      next if ($table && ($table ne $nfeed_schema_table));

      my @results = $db->Query($nfeed_schema_table, %params);

      print "/* $table */\n";
      print join(",", $nfeed_schema->{$nfeed_schema_table}->{index}, @{$nfeed_schema->{$nfeed_schema_table}->{columns}}), "\n";

      foreach my $row (@results) {
         print join(',', map {"\"$row->{$_}\""} $nfeed_schema->{$nfeed_schema_table}->{index}, @{$nfeed_schema->{$nfeed_schema_table}->{columns}}), "\n";
      }
      print "\n";
   }
}
elsif ($delete) {
   $db->Delete($table, %params);
}
