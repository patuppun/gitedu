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
my $query = '';
my $filter = 0;
my $help = 0;
my $debug = 0;
my $json = 1;

GetOptions('host=s' => \$host,
           'user|username:s' => \$username,
           'pass|password:s' => \$password,
           'query:s' => \$query,
           'help|?' => \$help,
           'debug' => \$debug,
           'filter:n' => \$filter,
           'json' => \$json,
           ) || exit 1;
if ($help) {
   print "Usage: query_jql.pl [--host <host:port>] [--user <username> [--password <password>]] --query <query string> field [...]\n";
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

my $search_fields = 'key,status,created';
my $expand = 'changelog,history';

if ($filter) {
   my $filter_data = &run_query("filter/$filter");
   if (defined($filter_data->{jql})) {
      $query = $filter_data->{jql};
   }
   else {
      print "unknown filter\n";
      exit 1;
   }
}

# perform JQL search
my $search = "search\?maxResults=1000";
$search .= "&expand=$expand" if ($expand);
$search .= "&fields=$search_fields" if ($search_fields);
$search .= "&jql=$query";

my $defects = &run_query($search);

# iterate over each defect
my %histories;
foreach my $defect (@{$defects->{issues}}) {
   my @history;
   push @history, [&dateTime($defect->{fields}->{created}, '%Y-%m-%dT%H:%M:%S.%3N'), 'Open'];

   if (defined($defect->{changelog})) {
      foreach my $change (@{$defect->{changelog}->{histories}}) {
         foreach my $item (@{$change->{items}}) {
            if ($item->{field} eq 'status') {
               push @history, [&dateTime($change->{created}, '%Y-%m-%dT%H:%M:%S.%3N'),$item->{toString}];
               last;
            }
         }
      }
   }
   else {
      my $history = &run_query("issue/$defect->{key}?fields=transitions&expand=changelog,history");

      foreach my $change (@{$history->{changelog}->{histories}}) {
         foreach my $item (@{$change->{items}}) {
   #         print "$defect->{key}: ($change->{created}) $item->{field} $item->{fromString} => $item->{toString}\n";
            if ($item->{field} eq 'status') {
               push @history, [&dateTime($change->{created}, '%Y-%m-%dT%H:%M:%S.%3N'),$item->{toString}];
   #            print "$change->{created}: $item->{toString}\n";
               last;
            }
         }
      }
   }
   $histories{$defect->{key}} = \@history;
}

my @dates = qw(1/1/2014 1/8/2014 1/15/2014 1/22/2014 2/1/2014 2/8/2014 2/15/2014 2/22/2014 3/1/2014 3/8/2014 3/15/2014 3/22/2014);
my %times = map {$_ => &dateTime($_, '%m/%d/%Y')} @dates;

my %open = map {$_ => 0} @dates;
my %closed = map {$_ => 0} @dates;
my %total = map {$_ => 0} @dates;

foreach my $key (sort(keys(%histories))) {
   my @history = @{$histories{$key}};
   foreach my $date (@dates) {
      my $time = $times{$date};

      my $final_state = '';

      foreach my $entry (@history) {
         my ($entry_time, $state) = @{$entry};
#         print $time->epoch(), ' <=> ', $entry_time->epoch(), ' = ', DateTime->compare($time, $entry_time), "\n";
         last if (DateTime->compare($time, $entry_time) < 0);
         $final_state = $state;
      }
#      print "$key: as of $date is '$final_state'\n";
      if ($final_state) {
         if ($final_state eq 'Open' || $final_state eq 'In Progress') {
            $open{$date}++;
         }
         elsif ($final_state eq 'Resolved') {
            $closed{$date}++;
         }
         $total{$date}++;
      }
   }
}

print "date,open,closed,total\n";
foreach my $date (@dates) {
   print "$date,$open{$date},$closed{$date},$total{$date}\n";
}

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
   $client->GET("/rest/api/latest/$query", $headers);
#   print "http://$host/rest/api/latest/$query\n" if ($debug);
#   print Dumper($client->responseContent()) if ($debug);
   my $response = from_json($client->responseContent());
#   print Dumper($response) if ($debug);
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

sub dateTime($) {
   my ($timestamp, $pattern) = @_;  # 2014-03-04T16:47:44.000-0500

   use DateTime::Format::Strptime;

   my $timezone = 'local';

   if ($timestamp =~ /^(.*?)(-\d\d\d\d)$/) {
      $timestamp = $1;
      $timezone = $2;
   }

   my $Strp = new DateTime::Format::Strptime(pattern     => $pattern,
                                             time_zone   => $timezone,
                                             on_error    => 'croak',
                                            );

   
   return $Strp->parse_datetime($timestamp);
}
