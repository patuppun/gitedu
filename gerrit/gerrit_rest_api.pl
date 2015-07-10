#!/export/electriccloud/electriccommander/bin/ec-perl
use strict;
use ElectricCommander;
use File::Path;
use Getopt::Long;
use Time::Local;
use JSON;
use LWP;
use Data::Dumper;

$| = 1;

my $debug = 0;
my $http = 0;

sub Log(@) { print STDERR scalar(localtime()), ": ", @_; }
sub Debug(@) { &Log(@_) if ($debug); }

my $server = 'gerrit-rtp-01.rtp.broadcom.com';
my $port = 8080;
my $runfor = 60;
my $username = '';
my $password = '';

GetOptions('debug'   => \$debug,
           'http'   => \$http,
           'server=s'   => \$server,
           'username=s'   => \$username,
           'password=s'   => \$password,
           'port=n'   => \$port,
           'runfor=n' => \$runfor,
           );

# Create a single instance of the Perl access to ElectricCommander
my $ec = new ElectricCommander();

## Connect to Gerrit and watch for new events
#if (open(STREAM, "ssh -p $port $host 'gerrit stream-events'|")) {
#   while (<STREAM>) {
#      my $event = from_json($_);
#      &Log("Event: $event->{type}\n");
#   }
#}

# Load username/password from .netrc file unless specified
unless ($username && $password)
{
   if (open(FILE, "<$ENV{HOME}/.netrc")) {
      foreach my $line (<FILE>) {
         if ($line =~ /^machine $server login (.*?) password (.*?)$/) {
            $username = $1;
            $password = $2;
            Debug("User found: $username\n");
            last;
         }
      }
   }
}

# Connect to Gerrit and pull change information

my $changes = &Query_Changes('status:open', 'CURRENT_REVISION');
print Dumper($changes);

foreach my $change (@{$changes}) {
   my $detail = Get_Change_Detail($change, 'LABELS');

   print Dumper($detail);
#   my $msg = {'message' => 'test comment',
#              'labels' => {},
#              'comments' => {},
#              };
#   &Set_Review($change, $msg);
}

###################################################################################################
#
# Gerrit API commands:
#
# Change Endpoints
#
#    Query Changes
sub Query_Changes($@) {
   my ($query, @options) = @_;
   &Debug("Query Changes: $query, [@options]\n");

   my $options = join('',map {'&o='.uc($_)} @options);
   return GET("changes/?q=$query$options");
}

#    Get Change
sub Get_Change($@) {
   my ($change, @options) = @_;
   &Debug("Get Change: $change->{id}, [@options]\n");

   my $options = join('&',map {'o='.uc($_)} @options);
   return GET("changes/$change->{id}?$options");
}

#    Get Change Detail
sub Get_Change_Detail($@) {
   my ($change, @options) = @_;
   &Debug("Get Change Detail: $change->{id}, [@options]\n");

   my $options = join('&',map {'o='.uc($_)} @options);
   return GET("changes/$change->{id}/detail?$options");
}

#    Get Topic
sub Get_Topic($@) {
   my ($change) = @_;
   &Debug("Get Topic: $change->{id}\n");

   return GET("changes/$change->{id}/topic");
}
#    Set Topic
#    Delete Topic
#    Abandon Change
#    Restore Change
#    Rebase Change
#    Revert Change
#    Submit Change
#    Publish Draft Change
#    Delete Draft Change
#    Get Included In
#
###################################################################################################
#
# Reviewer Endpoints
#
#    List Reviewers
#    Suggest Reviewers
#    Get Reviewer
#    Add Reviewer
#    Delete Reviewer
#
###################################################################################################
#
# Revision Endpoints
#
#    Get Commit
#    Get Review
#    Set Review
sub Set_Review($) {
   my ($change, $msg) = @_;

   &Debug("Set_Review:\n", Dumper($change), "\n", Dumper($msg), "\n");
   return POST("changes/$change->{id}/revisions/$change->{current_revision}/review", to_json($msg));
}

#    Rebase Revision
#    Submit Revision
#    Publish Draft Revision
#    Delete Draft Revision
#    Get Patch
#    Get Mergeable
#    Get Submit Type
#    Test Submit Type
#    Test Submit Rule
#    List Drafts
#    Create Draft
#    Get Draft
#    Update Draft
#    Delete Draft
#    List Comments
#    Get Comment
#    List Files
#    Get Content
#    Get Diff
#    Set Reviewed
#    Delete Reviewed
#    Cherry Pick Revision
#    Edit Commit Message

###################################################################################################
#
# BASIC GET/POST routines
#
sub POST($$) {
   my ($url, $data) = @_;

   my $browser = LWP::UserAgent->new;
   Debug("POST http://$server:$port/$url\n$data\n") if ($http);

   if ($username) {
      $browser->credentials("$server:$port", 'Gerrit Code Review', $username => $password);
      $url = "a/$url";
   }

   my $response = $browser->post("http://$server:$port/$url", 
                                 'Content-Type' => 'application/json',
                                 Content => $data);
   print Dumper($response) if ($http);

   unless ($response->is_success)
   {
      Debug($response->status_line(), "\n") if ($http);
      return undef;
   }
   my $content = $response->decoded_content;
   $content =~ s/\)\]\}\'\n//s;

   Debug($content) if ($http);
   return from_json($content);
}

sub GET($) {
   my ($url) = @_;

   my $browser = LWP::UserAgent->new;
   Debug("GET http://$server:$port/$url\n") if ($http);
   my $req = HTTP::Request->new( GET => "http://$server:$port/$url");
   $req->header('Accept' => 'application/json');

   if ($username) {
      $browser->credentials("$server:$port", 'Gerrit Code Review', $username => $password);
      $url = "a/$url";
   }

   my $response = $browser->request($req);

   print Dumper($response->request()) if ($http);
#   print Dumper($response);
   unless ($response->is_success)
   {
      Debug($response->status_line(), "\n") if ($http);
      return undef;
   }
   my $content = $response->decoded_content;
   $content =~ s/\)\]\}\'\n//s;

   Debug($content) if ($http);
   return from_json($content);
}
