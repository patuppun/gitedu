#!/usr/local/bin/perl
use strict;
use Net::LDAP;
use Getopt::Long;
use Data::Dumper;

$Data::Dumper::Sortkeys = 1;

my $help = 0;
my $debug = 0;
my $max = 0;
my $name_only = 0;
my $group_only = 0;
my $email_list = 0;

my $group = '';
my $file = '/tools/oss/packages/share/BRCM/etc/BRCMstaff_All.txt';
my $org = '';
my @users = ();
my @names = ();

GetOptions('help|?' => \$help,
           'debug' => \$debug,

# output filter
           'file=s' => \$file,
           'max=n' => \$max,
           'name-only' => \$name_only,
           'group-only' => \$group_only,
           'email-list' => \$email_list,

# selection filter
           'user=s' => \@users,
           'name=s' => \@names,
           'org=s' => \$org,
           'group=s' => \$group,

           );

$group = "\t$group" if ($group);
my @cc = @ARGV;

if ($help || !$file || (!@cc && !@users && !@names && !$org)) {
   print "Usage: userlist.pl --userlist <userfile> [--group <group name> ...] (--org <org owner>) | (<department> ...)\n";
   exit;
}

my @userfile = `cat $file`;
chomp(@userfile);

my $headers = shift(@userfile);
my @headers = split('\|', $headers);

@headers = map {$_ =~ s/\"//g; $_} @headers;

my %users;
my $count=0;
foreach my $line (@userfile) {
   my %user = ();
   my @values = split('\|', $line);
#   print STDERR "$line" if ($debug);
   foreach my $i (0..$#headers) {
      my $value = $values[$i];

      if ($value =~ /^\"(.*?)\"$/) {
         $value = $1;
      }
      $user{$headers[$i]} = $value;
   }

#   print STDERR Dumper(\%user) if ($debug);

   if ($user{Personnel_ID} && $user{Person_Status} eq 'A') {
      $users{$user{Personnel_ID}} = \%user;

#      if ($user{Supervisor_ID}) {
#         $supervisors{$user{Supervisor_ID}} ||= [];
#         push @{$supervisors{$user{Supervisor_ID}}}, $user{Personnel_ID};
#
#      }
#
#      if ($user{Acct_Name_Unix}) {
#         $usernames{$user{Acct_Name_Unix}} = $user{Personnel_ID};
#      }
#      if ($user{_Full_Name_}) {
#         $names{$user{_Full_Name_}} = $user{Personnel_ID};
#      }
#      if ($user{Cost_Center}) {
#         $costcenters{$user{Cost_Center}} ||= [];
#         push @{$costcenters{$user{Cost_Center}}}, $user{Personnel_ID};
#      }
      $count++;
   }
   last if ($max && $count >= $max);
}

print STDERR "$count active users loaded.\n";

# print selected users
if ($org) {
   my $user = &Find_Userid($org);

   &Print_Users($user, &Find_Supervised($user));
}


# Subroutines
sub Find_Userid($) {
   my ($userid) = @_;
   foreach my $user_id (keys(%users)) {
      my $user = $users{$user_id};
      return $user if ($user->{Acct_Name_Unix} eq $userid);
   }
   return undef;
}

sub Find_Supervised($) {
   my ($supervisor) = @_;
   my @supervised = ();

   foreach my $user_id (keys(%users)) {
      my $user = $users{$user_id};

      if ($user->{Supervisor_ID} && ($supervisor->{Personnel_ID} eq $user->{Supervisor_ID})) {
         print "$supervisor->{Full_Name} -> $user->{Full_Name}\n" if ($debug);
         push @supervised, $user;
         push @supervised, &Find_Supervised($user);
      }
   }
   return @supervised;
}

sub Print_Users(@) {
   my @users = @_;

   if ($group_only) {
      my %groups;
      foreach my $user (@users) {
         print Dumper($user) if ($debug);

         $groups{$user->{Cost_Center}} = $user->{Cost_Center_Name};
         $count++;
         last if ($max && $count >= $max);
      }

      print map {"$_\t$groups{$_}\n"} sort(keys(%groups));
   }
   else {
      foreach my $user (@users) {
         print Dumper($user) if ($debug);
         &print_user($user);
      }
   }
}

sub print_user($) {
   my ($user) = @_;

   my $username = $user->{Acct_Name_Unix} || $user->{Acct_Name_NT};
   next unless ($username && $username ne ' ');

   if ($name_only) {
      print "$user->{_Full_Name_}\n";
   }
   elsif ($email_list) {
      print "$user->{Email_Addr};";
   }
   else {
      print "$username\t$user->{Full_Name}\t$user->{Email_Addr}\t$group\n";
   }
}                             
