#!/usr/local/bin/perl
use strict;
use Cwd;

my $script_dir;
my $tools_dir;

BEGIN {
   my $script = $0;
   $script =~ s/\\/\//g;  #convert back to forward slashes to support Windows
   
   if ($script =~ /^(.*?\/contrib)\// || 
       $script =~ /^(.*?\/test)\// || 
       $script =~ /^(.*?\/tools)\//)
   {
      $tools_dir = $1;
   }
   else
   {
      $tools_dir = "../..";
      $tools_dir = "$1/$tools_dir" if ($script =~ /^(.*)\//);
   }
   print STDERR "Tools Dir: $tools_dir\n";
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
my $username = '';
my $password = '';
my $query = '';
my $filter = 0;
my $help = 0;
my $debug = 0;
my $json = 1;
my $dates = '';
my $id = '';

sub Debug() { print STDERR scalar(localtime()),": ", @_ if ($debug); }

GetOptions('host=s' => \$host,
           'user|username:s' => \$username,
           'pass|password:s' => \$password,
           'query:s' => \$query,
           'help|?' => \$help,
           'debug' => \$debug,
           'filter:n' => \$filter,
           'id=s' => \$id,
           'json' => \$json,
           'dates=s' => \$dates,
           ) || exit 1;
if ($help) {
   print "Usage: filter_history.pl [--host <host:port>] [--user <username> [--password <password>]] --query <query string> field [...]\n";
   exit;
}

&Debug("Host:   $host\n");
&Debug("Query:  $query\n");
&Debug("Filter: $filter\n");
&Debug("Dates:  $dates\n");

# prompt for username password if not provided
unless ($username && $password) {
   # check .netrc file
   if (open(FILE, "<$ENV{HOME}/.netrc")) {
      foreach my $line (<FILE>) {
         chomp($line);
         if ($line =~ /^machine $host login (.*?) password (.*?)$/) {
            $username = $1;
            $password = $2;
            &Debug("Found login for $host: $username\n");
         }
      }
   }
   unless ($username) {
      print STDERR "Unknown user.\n";
      exit;
   }

#   ($username, $password) = &login($username, $password);
}

# determine custom field name mapping
my $fields = &rerun_query(5, 'field');
my %field_map;
my %field_name_map;

foreach my $field (@{$fields}) {
   $field_map{$field->{id}} = $field->{name};
   $field_name_map{lc($field->{name})} = $field->{id};
}

my $search_fields = 'key,status,created,updated';
my $expand = 'changelog,history';

if ($filter) {
   my $filter_data = &rerun_query(5, "filter/$filter");
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

&Debug("Loading jira issues...\n");
my $defects = &rerun_query(5, $search);

# iterate over each defect
my %histories;
foreach my $defect (@{$defects->{issues}}) {
   next if ($id && $id ne $defect->{key});
   print Dumper($defect) if ($debug && $id);
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
      my $history = &rerun_query(5, "issue/$defect->{key}?fields=transitions&expand=changelog,history");

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
   push @history, [&dateTime($defect->{fields}->{updated}, '%Y-%m-%dT%H:%M:%S.%3N'), $defect->{fields}->{status}->{name}];

   $histories{$defect->{key}} = \@history;
}

my @dates = split(/[;,]/, $dates);
my %times = map {$_ => &dateTime($_, '%Y-%m-%d')} @dates;

my %open_states = map {$_=> 1} ('Open', 'Accepted', 'In Progress', 'Review', 'Merge', 'Assigned', 'Analyzed');
if ($host =~ /^jira-ccxsw/) {
   %open_states = map {$_=> 1} ('Analyze', 'Assigned', 'Open', 'Reopened', 'In Progress', 'Review', 'Pending');
}

my %verify_states = map {$_=> 1} ('Verify');

my %titles = (open => 'Open Defects',
              total => 'Total Defects',
              verify => 'Verify',
             );


my %counts;
foreach my $group (keys(%titles)) {
   $counts{$group} = {map {$_ => 0} @dates};
}
#print Dumper(\%counts) if ($debug);

my $now = DateTime->now();

while ($dates[-1] && DateTime->compare($now, $times{$dates[-1]}) > 0) {
   my $new = $times{$dates[-1]}->clone();
   $new->add(weeks => 1);
   push @dates, $new->ymd();
   $times{$new->ymd()} = $new;
   &Debug("Adding date: $new\n");
}

foreach my $key (sort(keys(%histories))) {
   next if ($id && $id ne $key);
   my @history = @{$histories{$key}};
   print Dumper(\@history) if ($debug && $id);
   foreach my $date (@dates) {
      my $time = $times{$date};

      my $final_state = '';

      foreach my $entry (@history) {
         my ($entry_time, $state) = @{$entry};
#         print $time->epoch(), ' <=> ', $entry_time->epoch(), ' = ', DateTime->compare($time, $entry_time), "\n";
         last if (DateTime->compare($time, $entry_time) < 0);
         $final_state = $state;
      }
      if ($final_state) {
#         &Debug("$key: as of $date is '$final_state'\n");
         if (defined($open_states{$final_state})) {
            $counts{open}->{$date}++;
            &Debug("$key is open\n");
         }
         if (defined($verify_states{$final_state})) {
            $counts{verify}->{$date}++;
#            &Debug("$key is verify\n");
         }
         $counts{total}->{$date}++;
      }
      last if (DateTime->compare($now, $time) < 0);
   }
}

print "Date,", join(',', @dates), "\n";
foreach my $group (sort(keys(%titles))) {
   my $tally = join('', map {",". ($counts{$group}->{$_} || '')} @dates);
 
   # remove trailing blanks
   $tally =~ s/[,]+$/,/;

   # replace prefix blanks with 0
   $tally =~ s/,(?=,)/,0/g;

   print "$titles{$group}$tally\n";
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

sub rerun_query($$) {
   my ($times, $query) = @_;

   while ($times) {
      $times--;
      my $result = &run_query($query);
      return $result if ($result);
   }
   return '';
}

sub run_query($) {
   my ($query) = @_;
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($username . ':' . $password)};
   my $client = REST::Client->new();
   $client->setHost("http://$host");
   $client->GET("/rest/api/latest/$query", $headers);
#   print "http://$host/rest/api/latest/$query\n" if ($debug);
#   print Dumper($client->responseContent()) if ($debug);
   my $response = $client->responseContent();
   if ($response =~ /<html>/) {
      return undef;
   }
   my $response = from_json($response);
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
