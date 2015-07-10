use strict;
use Net::LDAP;
use Getopt::Long;
use Data::Dumper;

my $help = 0;
my $debug = 0;

my $group = '';
my $userlist = '';
my $org = '';
my @users = ();

GetOptions('help|?' => \$help,
           'group=s' => \$group,
           'userlist=s' => \$userlist,
           'user=s' => \@users,
           'org=s' => \$org,
           'debug' => \$debug,
           );
my @depts = @ARGV;

if ($help || (!@depts && !@users && !$userlist && !$org)) {
   print "Usage: ldap.pl [--group <group name> ...] --org <org owner> --userlist <userfile> | <department> ...\n";
   exit;
}

my %var = map {$_ => ''} qw(ldap_userid ldap_userpw ldap_host ldap_base);

foreach my $line (`cat $ENV{HOME}/ldap.config`) {
   chomp($line);
   if ($line =~ /^(.*?)\s*=\s*(.*?)$/) {
      next unless ($1);
      $var{$1} = $2;
   }
}

exit 1 unless ($var{ldap_userpw});
#INITIALIZING

my $ldap = Net::LDAP->new ( $var{ldap_host} ) or die "$@";

#BINDING

my $mesg = $ldap->bind ( version => 3 );          # use for searches

$mesg = $ldap->bind ( $var{ldap_userid},           
                      password => $var{ldap_userpw},
                      version => 3 );          # use for changes/edits

# see your LDAP administrator for information concerning the
# user authentication setup at your site.


sub LDAPerror
{
  my ($from, $mesg) = @_;
  print "Return code: ", $mesg->code;
  print "\tMessage: ", $mesg->error_name;
  print " :",          $mesg->error_text;
  print "MessageID: ", $mesg->mesg_id;
  print "\tDN: ", $mesg->dn;
}

#OPERATION - Generating a SEARCH

sub LDAPsearch
{
  my ($ldap,$searchString,$attrs,$base) = @_;

  # if they don't pass a base... set it for them

  if (!$base ) { $base = "o=mycompany, c=mycountry"; }

  # if they don't pass an array of attributes...
  # set up something for them

  if (!$attrs ) { $attrs = [ 'cn','mail' ]; }

  return $ldap->search ( base    => "$base",
                         scope   => "sub",
                         filter  => "$searchString",
                         attrs   =>  $attrs
                       );
}
my @Attrs = ( );               # request all available attributes
                               # to be returned.

foreach my $dept (@depts) {
  my $group_name = $group || "dept-$dept";
 
  my $result = LDAPsearch ( $ldap, "department=$dept-*", \@Attrs, "$var{ldap_base}" );
 
  if ( $result->code ) {
    # if we've got an error... record it
    LDAPerror ( "Searching", $result );
  }
 
  my @entries = $result->entries;
 
#  print results;
  foreach my $entr ( @entries ) {
 #   print "DN: ", $entr->dn, "\n";
 
    my $username = $entr->get_value ( 'name' );
    my $name = $entr->get_value ( 'displayName' );
    my $email = $entr->get_value ( 'mail' ) || $entr->get_value ( 'sAMAccountName' ).'@broadcom.com';
 
    print "$username\t$name\t$email\t$group_name\n";
  }
}


if ($org) {
   my $cmd = "wget \"http://ace.broadcom.com/orgchart/?contractor=1;personnel_key=$org;count=1;noframe=1\" -qO-";
   print STDERR ">$cmd\n" if ($debug);
   my @html = `$cmd`;
   foreach my $line (@html) {
      if ($line =~ />([^<>]*?)<\/a><(b|\/TD)/) {
         my $user = $1;
#         $user =~ s/\(.*?\) //g;
         next if ($user =~ /^\s*$/);
         push @users, $user;
         print STDERR "$user\n";
      }
   }
}

if ($userlist) {
   @users = `cat $userlist`;
   chomp(@users);
}

foreach my $user (@users) {
   print STDERR "$user:\n" if ($debug);
   my $search_user = $user;
   $search_user =~ s/\(/\\\(/g;
   $search_user =~ s/\)/\\\)/g;

   my $result = LDAPsearch ( $ldap, "displayName=$search_user", \@Attrs, "$var{ldap_base}" );

   if ( $result->code ) {
     print STDERR "Error: $user:\n";
     # if we've got an error... record it
     LDAPerror ( "Searching", $result );
     exit;
   }

   my @entries = $result->entries;

   my $count=0;

   foreach my $entr ( @entries ) {
     my $username = $entr->get_value ( 'name' );
     my $name = $entr->get_value ( 'displayName' );
     my $email = $entr->get_value ( 'mail' ) || $entr->get_value ( 'sAMAccountName' ).'@broadcom.com';
     my $dept = $entr->get_value ( 'department' );
     $dept =~ s/-.*$//;

     my $description = $entr->get_value ( 'description' );
     if (!$dept || $description =~ /disabled/) {
        print STDERR "Ignoring: $username ($name)\n" if ($debug);

        print STDERR $entr->dump() if ($debug);
        next;
     }

     my $group_name = $group || "dept-$dept";

     print "$username\t$name\t$email\t$group_name\n";
     $count++;
   }

   unless ($count) {
      print STDERR "Unknown user: $user\n";
   }
}
