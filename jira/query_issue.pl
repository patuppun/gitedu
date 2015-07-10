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
my $id = '';
my $help = 0;
my $debug = 0;
my $json = 0;

GetOptions('host=s' => \$host,
           'user|username:s' => \$username,
           'pass|password:s' => \$password,
           'id:s' => \$id,
           'help|?' => \$help,
           'debug' => \$debug,
           'json' => \$json,
           ) || exit;
if ($help) {
   print "Usage: check_jira.pl [--host <host:port>] [--user <username> [--password <password>]] --id <jira ID> field [...]\n";
   exit;
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

# print field names
foreach my $field (@ARGV) {
   next unless ($field);
   my $field_id = $field_name_map{lc($field)} || $field;
   my $field_name = $field_map{$field_id};
   print "$field_name," unless ($json);
}
print "\n" unless ($json);

# iterate over each defect
my @fields = @ARGV;
@fields = grep {$_ !~ /^_/} keys(%field_name_map) unless (@ARGV);

# perform issue search
my $defect = &run_query("issue/$id?expand=attachment&fields=*all");
if (defined($defect) && defined($defect->{errorMessages})) {
   if ($json) {
      print to_json($defect);
   }
   else {
      print map {"Error: $_\n"} @{$defect->{errorMessages}};
   }
   exit 1;
}
my %hash;
foreach my $field (@fields) {
   next unless ($field);
   my $field_id = $field_name_map{$field} || $field;
   my $field_name = $field_map{$field_id};
   print "$field: $field_id -> $field_name\n" if ($debug);
   my $field_value = ($field eq 'key' ? $defect->{$field} : $defect->{fields}->{$field_id}) || '';

   if (ref($field_value) eq 'HASH') {
      if (defined($field_value->{emailAddress})) {
         $field_value = "$field_value->{name} <$field_value->{emailAddress}>";
      }
      else {
         $field_value = $field_value->{name} || $field_value->{value};
      }
   }
   print "$field_name = $field_value\n" if ($debug);
   if ($json) {
      $hash{$field_name} = $field_value if ($field_value);
   }
   else {
      $field_value = &toCSV($field_value);
      print "$field_value,";
   }
}
print to_json(\%hash),"\n" if ($json);
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
   print "> $query\n" if ($debug);
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

