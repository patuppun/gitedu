#!perl
# usage:
# perl export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --query 14155 --user cpverne --max 1 --nfeed nfeed_values.csv --file rtpjira_ids.txt
# perl export_jira.pl --server engjira.sj.broadcom.com:8080 --query 21985

use strict;
use Getopt::Long;
use REST::Client;
use MIME::Base64;
use Data::Dumper;
use JSON;

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my $max = 0;
my $server = '';
my $project = '';
my $username = '';

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

GetOptions('debug'     => \$debug,
           'server=s'  => \$server,
           'project=s' => \$project,
           'max=n'     => \$max,
           'user=s'    => \$username,
           );

my $usage = "Usage: empty_jira_project.pl --server <server> --project <project>";

unless ($server) {
   msg("$usage\n\tserver must be specified.\n");
   exit 1;
}

my ( $user, $password ) = &login($username);

# set up query to get issues.	
my $src_headers = { 'Content-Type' => 'application/json',        
                    Authorization  => 'Basic ' . encode_base64($user . ':' . $password),
                  };


# determine number of issues.
my $issues = &run_query("search?jql=project%3D$project&startAt=0&maxResults=0");
unless ($issues) {
   msg("Could not run query: project = $project\n");
   exit 1;
}
my $total = $issues->{'total'};
msg("Total issues: $total\n");

my @issues = ();

my $startAt = 0;
my $maxResults = 1000;
my $done = 0;

my $starttime = time();
while (!$done) {
   if ($startAt < $total) {
      $issues = &run_query("search?jql=project%3D$project&startAt=$startAt&maxResults=$maxResults&fields=key");
      $startAt += $maxResults;
      if ($issues) {
         push @issues, @{$issues->{issues}};
      }
      else {
         $done = 1;
      }
   }
   else {
      $done = 1;
   }
}

msg("Retrieved ", scalar(@issues), " records.\n");
msg("   Start:        ", scalar(localtime($starttime)), "\n");
msg("   End:          ", scalar(localtime()), "\n");
msg("   Duration:     ", time() - $starttime, "\n");
msg("   Seconds Each: ", sprintf("%0.3f", (time() - $starttime)/scalar(@issues)), "\n");

msg("Deleting records...\n");
$starttime = time();
my $count = 0;
foreach my $issue (@issues) {
   $count++;
   my $key = $issue->{key};

   msg("$key\n");
   &run_query("issue/$key", '', 'DELETE');

   last if ($max && $count >= $max);
}

msg("   Start:        ", scalar(localtime($starttime)), "\n");
msg("   End:          ", scalar(localtime()), "\n");
msg("   Duration:     ", time() - $starttime, "\n");
msg("   Count:        $count\n");
msg("   Seconds Each: ", sprintf("%0.3f", (time() - $starttime)/$count), "\n");

sub login {
    use Term::ReadKey;
    my ($user, $password) = @_;

    unless ($user) {
       if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
          foreach my $line (<NETRC>) {
             chomp($line);
             if ($line =~ /^machine jira login (.*?) password (.*?)$/) {
                $user = $1;
                $password = $2;
                last;
             }
          }
       }
    }

    until ($user) {
       print STDERR "Username: ";
       $user = ReadLine(0);
    }

    until ($password) {
        print STDERR "Password: ";
        ReadMode('noecho');
        $password = ReadLine(0);
        ReadMode('normal');
        print STDERR "\n";
    }
    chomp($user);
    chomp($password);

    return ( $user, $password );
}

sub run_query($$) {
   my ($query, $api,$op) = @_;
   $api ||= '/rest/api/2';
   $op ||= 'GET';
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
   my $client = REST::Client->new();
   $client->setHost("http://$server");
   debug(">$api/$query\n");
   if ($op eq 'GET') {
      $client->GET("$api/$query", $headers);
   }
   elsif ($op eq 'DELETE') {
      $client->DELETE("$api/$query", $headers);
   }
   if ($client->responseCode()==200) {
      debug(Dumper($client->responseContent()));
      my $response = from_json($client->responseContent());
      debug(Dumper($response));
      return $response;
   }
   else {
      msg($client->responseContent());
      return undef;
   }
}

