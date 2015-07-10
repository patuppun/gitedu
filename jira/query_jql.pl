use strict;
use Cwd;

my $script_dir;
my $tools_dir;

BEGIN {
	$script_dir = ( $0 =~ m#^(.*)[/\\][^\\/]+$# ) ? $1 : '.';
	$script_dir = cwd() if ( $script_dir eq '.' );
	$script_dir =~ s#\\#/#g;
	$script_dir =~ s#^(\w):#/cygdrive/$1#;

        $tools_dir = ($script_dir =~ m#^(.*)[/\\][^\\/]+$# ) ? $1 : '..';
        $tools_dir = cwd().'/..' if ( $tools_dir eq '..' );
}

use lib "$tools_dir/perllib";

use REST::Client;
use JSON;
# Data::Dumper makes it easy to see what the JSON returned actually looks like
# when converted into Perl data structures.
use Data::Dumper;
use MIME::Base64;
use Getopt::Long;
 
my $host = "jira-ccxsw.rtp.broadcom.com:8080";
my $username = '';
my $password = '';
my $query = '';
my $help = 0;
my $debug = 0;
my $json = 0;

GetOptions('host=s' => \$host,
           'user|username:s' => \$username,
           'pass|password:s' => \$password,
           'query:s' => \$query,
           'help|?' => \$help,
           'debug' => \$debug,
           'json' => \$json,
           ) || exit;
if ($help) {
   print "Usage: query_jql.pl [--host <host:port>] [--user <username> [--password <password>]] --query <query string> field [...]\n";
   exit;
}

unless ($username) {
   if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
     foreach my $line (<NETRC>) {
       chomp($line);
       if ($line =~ /^machine $host login (.*?) password (.*?)$/) {
         $username = $1;
         $password = $2;
         last;
       }
     }
   }
}

# prompt for username password if not provided
unless ($username && $password) {
   ($username, $password) = &login($username, $password);
}

# determine custom field name mapping
my $fields = &run_query('field');
my %field_map;
my %field_name_map;

foreach my $field (@{$fields}) {
   $field_map{$field->{id}} = $field->{name};
   $field_name_map{lc($field->{name})} = $field->{id};
}

# perform JQL search
my $defects = &run_query('search?expand=attachment&fields=*all&jql='.$query);

# print field names
foreach my $field (@ARGV) {
   next unless ($field);
   my $field_id = $field_name_map{lc($field)} || $field;
   my $field_name = $field_map{$field_id};
   print "$field_name," unless ($json);
}
print "\n" unless ($json);

# iterate over each defect
my @array;
my @fields = @ARGV;
@fields = grep {$_ !~ /^_/} keys(%field_name_map) unless (@ARGV);

foreach my $defect (@{$defects->{issues}}) {
   my %hash;
   foreach my $field (@fields) {
      next unless ($field);
      my $field_id = $field_name_map{$field} || $field;
      my $field_name = $field_map{$field_id};
      my $field_value = ($field eq 'key' ? $defect->{$field} : $defect->{fields}->{$field}) || '';
      if (ref($field_value) eq 'HASH') {
         $field_value = $field_value->{name};
      }
      if ($json) {
         $hash{$field_name} = $field_value if ($field_value);
      }
      else {
         $field_value = &toCSV($field_value);
         print "$field_value,";
      }
   }
   if ($json) {
      push @array, \%hash;
   }
   else {
      print "\n" unless ($json);
   }
}
print to_json(\@array),"\n" if ($json);
#print Dumper($response);

sub toList {
   my $data = shift;
   my $key = shift;
   if (ref($data->{$key}) eq 'ARRAY') {
       $data->{$key};
   } elsif (ref($data->{$key}) eq 'HASH') {
       [$data->{$key}];
   } else {
       [];
   }
}

sub login {
    use Term::ReadKey;
    my ($username, $password) = @_;
    until ($password) {
        unless ($username) {
           print STDERR "Username: ";
           $username = ReadLine(0);
           chomp($username);
        }
        print STDERR "Password: ";
        ReadMode('noecho');
        $password = ReadLine(0);
        chomp($password);
        print STDERR "\n";
        ReadMode('normal');
    }

    return ( $username, $password );
}

sub run_query($) {
   my ($query) = @_;
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($username . ':' . $password)};
   my $client = REST::Client->new();
   $client->setHost("http://$host");
   $client->GET("/rest/api/2/$query", $headers);
   print Dumper($client->responseContent()) if ($debug);
   my $response = from_json($client->responseContent());
   print Dumper($response) if ($debug);
   return $response;
}

sub toCSV($) {
   my ($value) = @_;
   my $quote = 0;
   if ($value =~ /"/s) {
      $value =~ s/"/""/gs;
      $quote = 1;
   }
   if ($value =~ /,/s || $value =~ /^\s+/s || $value =~ /\s+$/s || $value =~ /\n/s) {
      $quote = 1;
   }

   if ($quote) {
      $value = "\"$value\"";
   }
   return $value;
}

