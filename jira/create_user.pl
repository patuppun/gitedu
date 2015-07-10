#!/usr/local/bin/perl
use strict;     # Perl pragma to restrict unsafe constructs
use warnings;   # Perl pragma to enable all optional warnings
use Cwd;
use File::Path;
use Data::Dumper;

my $tools_dir;
BEGIN 
{
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
   print "Tools Dir: $tools_dir\n";
}
use lib "$tools_dir/perllib";

# Fetch user and password from .netrc file

my $username = '';
my $password = '';

unless ($username) {
   if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
     foreach my $line (<NETRC>) {
       chomp($line);
       if ($line =~ /^machine jira login (.*?) password (.*?)$/) {
         $username = $1;
         $password = $2;
         last;
       }
     }
   }
}

unless ($username) {
   print "Error: No user found in $ENV{HOME}/.netrc\n";
   exit 1;
}

# Process arguments
use Getopt::Long qw(:config pass_through);

my $help = 0;
my $debug = 0;

my $user = '';
my $email = '';
my $name = '';
my @groups = ();

GetOptions('help|?' => \$help,
           'debug' => \$debug,
           'user=s' => \$user,
           'email=s' => \$email,
           'name=s' => \$name,
           'group=s' => \@groups,
           );

$email ||= "$user\@broadcom.com";
$name ||= $user;

use REST::Client;
use JSON;
use MIME::Base64;
 
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

my $client = REST::Client->new();
$client->setHost('http://jira-rtp-04.rtp.broadcom.com:8080');

#&get_users('jira-developers');

# get the user
my $user_obj = &get_user($user);
unless ($user_obj) {
   &create_user($user, $email, $name);
   $user_obj = &get_user($user);
}
#if ($user_obj) {
#   &set_user_group($user, @groups);
#   $user_obj = &get_user($user);
#}
exit;

sub get_users($) {
   my ($group) = @_;
   my $users = &get("group?groupname=$group");
}

# user management routines
sub get_user($) {
   my ($user) = @_;

   print STDERR "DEBUG: Get user: $user\n" if ($debug);
   my $response = &get("user?username=$user&expand=groups");
   return $response;
}

sub create_user($$$) {
   my ($user, $email, $name) = @_;
   # user doesn't exist, create the user
   my $data = {"name"=> $user,
               "password" => '',
               "emailAddress" => $email,
               "displayName" => $name,
              };

   print STDERR "DEBUG: Create user: $user\n" if ($debug);
   return &post("user?username=$user", $data);
}

sub set_user_group($@) {
   my ($user, @groups) = @_;

   foreach my $group (@groups) {
      print STDERR "DEBUG: Add user $user to group $group\n" if ($debug);
      my $data = {username=>$user};
      my $response = &post("group/user?groupname=$group", $data);
   }

}


# base routines

sub get($) {
   my ($uri) = @_;
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($username . ':' . $password)};
   $client->GET("/rest/api/2/$uri",$headers);
   my $response = from_json($client->responseContent());
   if (defined($response->{errors})) {
      print STDERR "Error: ", join("\n", @{$response->{errorMessages}}), "\n";
      return undef;
   }
   print Dumper($response) if ($debug);
   return $response;
}

sub post($$) {
   my ($uri, $data) = @_;
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($username . ':' . $password)};
   $headers->{'Content-Type'} ||= 'application/json;charset=UTF-8';
   print STDERR "POST: $uri\n";
   my $response = $client->POST("/rest/api/2/$uri", to_json($data), $headers);
   if (defined($response->{errors})) {
      print STDERR "Error: ", join("\n", @{$response->{errorMessages}}), "\n";
      return undef;
   }
   print Dumper($response) if ($debug);
   return $response;
}
