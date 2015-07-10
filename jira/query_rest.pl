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
 
my $host = "jira-rtp-04.rtp.broadcom.com:8080";
my $username = 'querier';
my $password = 'ccxquerier';
my $get = '';
my $set = '';
my $post = '';
my $data = '';
my $filter = 0;
my $help = 0;
my $debug = 0;
my $json = 1;

my $usage = "Usage: query_rest.pl [--host <host:port>] [--user <username> [--password <password>]] (--get <query string> | --set <query string> | --post <query string>) --data <data>\n";

GetOptions('host=s' => \$host,
           'user|username:s' => \$username,
           'pass|password:s' => \$password,
           'get:s' => \$get,
           'set:s' => \$set,
           'post:s' => \$post,
           'data:s' => \$data,
           'help|?' => \$help,
           'debug' => \$debug,
           ) || exit 1;
if ($help) {
   print $usage;
   exit;
}

my $query = undef;
my $op = undef;

if ($get) {
   $query = $get;
   $op = 'GET';
}
elsif ($set) {
   $query = $set;
   $op = 'SET';
}
elsif ($post) {
   $query = $post;
   $op = 'POST';
}
else {
   print $usage;
   exit 1;
}

my $op_data = undef;
if ($data) {
  $op_data = from_json($data);
}

# prompt for username password if not provided
unless ($username && $password) {
   ($username, $password) = &login($username, $password);
}

# determine custom field name mapping
my $return = &run_query($op,$query,$data);

print to_json($return, {pretty => 1, canonical => 1});

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
   my ($op,$query,$data) = @_;
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($username . ':' . $password)};
   my $client = REST::Client->new();
   $client->setHost("http://$host");
   if ($op eq 'GET') {
      $client->GET("/rest/api/latest/$query", $headers, $data);
   }
   elsif ($op eq 'SET') {
      $client->SET("/rest/api/latest/$query", $headers, $data);
   }
   elsif ($op eq 'POST') {
      $client->POST("/rest/api/latest/$query", $headers, $data);
   }
#   print "http://$host/rest/api/latest/$query\n" if ($debug);
#   print Dumper($client->responseContent()) if ($debug);
   my $response = from_json($client->responseContent());
#   print Dumper($response) if ($debug);
   return $response;
}
