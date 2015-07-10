#!/usr/local/bin/perl
use strict;
use FindBin qw($Bin $Script);
use lib "$Bin/../perllib";

use Getopt::Long;
use Data::Dumper;
use JSON;
use Gerrit::REST;

my $debug = 0;

my $gerrit_server = 'gerrit-ccxsw.rtp.broadcom.com';
my @options;

my $username = '';
my $password = '';

# Load commandline options
GetOptions('debug'     => \$debug,

           'gerrit=s'  => \$gerrit_server,
           'option=s'  => \@options,
           );

# Sub-routines
sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }

sub dhms($) {
   my ($sec) = @_;
   my $min = sprintf($sec / 60);
   $sec %= 60;
   my $hour = int($min / 60);
   $min %= 60;
   my $day = int($hour / 24);
   $hour %= 24;

   $min = "0$min" if ($min < 10);
   $sec = "0$sec" if ($sec < 10);

   my @parts;
   push @parts, "${day}d " if ($day);
   push @parts, "${hour}:${min}:${sec}";
   return join('', @parts);
}

# load username/password from .netrc file
unless ($username) {
   if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
      foreach my $line (<NETRC>) {
         chomp($line);
         if ($line =~ /^machine $gerrit_server login (.*?) password (.*?)$/) {
            $username = $1;
            $password = $2;
            last;
         }
      }
   }
}
unless ($username) {
   msg("No username configured...\n");
   exit 1;
}

# connect to Gerrit
my $gerrit = Gerrit::REST->new("http://$gerrit_server:8080", $username, $password);

my $query = join('+', @ARGV);
my $options = join('', map {"&o=$_"} @options);
my $rc = eval {$gerrit->GET("/changes/?q=$query$options")};

if ($@) {
   print STDERR Dumper($rc);
   exit 1;
}
print to_json($rc, {pretty => 1});
exit;

