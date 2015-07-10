#!/usr/local/bin/perl -w

# This script adds new users to Jira if they don't already exist and optionally
# adds the users to a Jira group, creating the group if necessary.
#
# Input comes from STDIN where each line has the following tab separated fields:
#
# <Userid> <FullName> <Email Addr> <Group>
#
# Example:
#   hmack   Hans Mack       hans.mack@broadcom.com  dept3443
#   wattana Chris Wattana   wattana@broadcom.com    dept3010
#   gregd   Greg D'Hondt    gregd@broadcom.com      
#
# If the group is not specified, addUserToGroup() is not called.
#
# Usage:
#
#   <mysql command> | ./JiraCreateUsers.pl [-x] [--var=value]
#
#                        -x          : Really execute (default is dry run)
#                        --var=value : override variables from command line
#                                      (example: --dbg=1)
#

# Following variables should be set in JiraCreateUsers.config

$jira_url = "http://NOT_SET.broadcom.com" ;
$jira_proxy = "rpc/soap/jirasoapservice-v2?wsdl" ;

$userid = "NOT_SET" ;
$userpw = "NOT_SET" ;
$dbg = 0 ; # debug flag ;

require "$ENV{HOME}/JiraCreateUsers.config" ;

# Process args

$x = 0 ; # Execute flag

foreach $arg ( @ARGV )
{
  $x = 1 if $arg eq "-x" ;
  ${$1} = $2 if $arg =~ /^--(\w+)=(.*)$/ ; # Ex: --dbg=1
}

@ARGV = ( "-" ) ; # Reset @ARGV to read STDIN

($soap,$token) = &SoapLogin($jira_url,$userid,$userpw) ;

$newpw = "YourWindowsPW" ; # Passwd can't be empty, but can  be anything since
                  # ldap will be used

# Process each line from STDIN
my $count = 0;
my $ignore = 0;
while(<>)
{
  chomp ;
  warn "$_\n" if $dbg ;

  local ($newid,$fullname,$email,@groups) = split("\t") ; # split tabs
  @groups = grep {$_} @groups;
  local %groups = map {$_ => 1} @groups;

  next if $newid =~ m#^\s*$#i ;        # empty string
  next if $newid =~ m#^\s*n/a\s*$#i ;  # n/a string

  $ignore++;
  next unless $email =~ /\@broadcom.com$/ ;

  $newid = lc($newid) ;  # Only lower case ids allowed in Jira

  # Ignore users with odd chars in fullname which causes failure
  # We may need to change Jira to UTF8
  next if $newid eq "fferhani" ;
  next if $newid eq "kerrynn" ;
  next if $newid eq "daniela" ;

  $fullname =~ s/[^[:ascii:]]//g;

  # Check if user already exists
  $remoteUser = $soap->getUser($token,$newid)->result() ;
  %currentGroups = ();

  if ( $remoteUser )
  {
    warn("remoteUser = ",Dumper($remoteUser)) if $dbg ;
    
    my $changedUser = 0;
    # print if FullName or Email has changed
    if ($remoteUser->{fullname} ne $fullname) {
         print "NOTICE: FullName changed from '$remoteUser->{fullname}' to '$fullname' for $newid\n";
         $remoteUser->{fullname} = $fullname; 
         $changedUser = 1;
    }

    if ($remoteUser->{email} ne $email) {
         print "NOTICE: Email changed from '$remoteUser->{email}' to '$email' for $newid\n";
         $remoteUser->{email} = $email; 
         $changedUser = 1;
    }

    $count++;

    if ($changedUser){ 
        $soap->updateUser($token,$remoteUser) if $x;
    }

    $group_array_p  = $soap->getUsersGroups($token,$newid)->result();
    %currentGroups = map {$_ => 1} @{$group_array_p};
    warn("user groups = ",Dumper($group_array_p)) if $dbg ;

    # iterate over existing groups
    foreach my $group (@{$group_array_p}) {
      next unless ($group =~ /^dept/ || $group =~ /^CC/) ; # skip to next group

      # Check if dept-group has changed

      if (!defined($groups{$group})) {
        print "NOTICE: Dept group changed from '$group' for $newid\n" ;
        print "NOTICE: Removing user '$newid' from group '$group'\n" ;
        my $remoteGroup = &getGroup($token,$group);
        $soap->removeUserFromGroup($token,$remoteGroup,$remoteUser) if $x ;
      }
    }
  }
  else
  {
    # Following line is just a reference of how to delete a user
    # $soap->deleteUser( $token, $newid) ;

    # Create new user

    unless ( $remoteUser )
    {
      print "INFO: Creating user for: $newid,$fullname,$email\n" ;
      
      $soap->extendedCreateUser( $token,$newid,$newpw,$fullname,$email) if $x ;

      $remoteUser = $soap->getUser($token,$newid)->result() if $x ;
    }
  }

  print "Groups: ".Dumper(\@groups)."\n";
  print "Current Groups: ".Dumper(\%currentGroups)."\n";
  # Group processing
  # iterate over groups
  foreach my $group (@groups) {
    next if (defined($currentGroups{$group}));

    my $remoteGroup = &getGroup($token,$group);

    unless ( defined $remoteGroup )
    {
      print "INFO: Creating group: $group\n" ;
      print "INFO: Adding '$newid' to group: $group\n" ;
      if ( $x )
      {
        $soap->createGroup($token,$group,$remoteUser) ;
        $remoteGroup = &createDummyGroup($group) ;
        $remoteGroup{$group} = $remoteGroup  ; # Save in assoc array
      }
    }
    elsif ( $x )
    {
      print "INFO: Adding '$newid' to group: $group\n" ;
      eval { $soap->addUserToGroup($token,$remoteGroup,$remoteUser) } ;
      warn $@ if $@ ;
    }
  }
}

$soap->logout($token);
print "Done. ($count, $ignore)\n";
exit 0;

# =============================================================================
sub SoapLogin
{
  local($jira_url,$userid,$userpw) = @_ ;

  # SOAP interface to JIRA

  use SOAP::Lite;
  use Data::Dumper;

  # Create SOAP object and define default error handling code

  warn("proxy = $jira_url/$jira_proxy") if $dbg ;

  local $soap = SOAP::Lite
    ->proxy("$jira_url/$jira_proxy")
    -> on_fault(
         sub { my($soap, $res) = @_;
               die "ERROR($0):\n", ref $res ? $res->faultstring
                                            : $soap->transport->status, "\n";
         } ) ;

  # SOAP Login

  local $token = $soap->login($userid,$userpw)->result() ;

  return ($soap,$token) ;
}

# =============================================================================
sub createDummyGroup
{
  local($group) = @_ ;

  # Create empty remoteGroup data structure for faster user add to group

  # It seems that Jira updates the group just fine even though this dummy
  # remoteGroup data structure is passed instead of the real remoteGroup.
  # When the real remoteGroup was used, it took a long time for Jira
  # to work its way through all the users before adding a new one.

  local $remoteGroup = bless( { 'name'  => $group,
                                'users' => [ ]
                              },'RemoteGroup' ) ;
  return $remoteGroup ;
}

sub getGroup {
   my ($token, $group) = @_;

   my $remoteGroup;

   if ( defined $remoteGroup{$group} )
   {
     $remoteGroup = $remoteGroup{$group} ; # Restore from previously saved hash
   }
   else
   {
     eval { $remoteGroup = $soap->getGroup($token,$group)->result() } ;
     warn $@ if $@ && $dbg ;

     if ( defined $remoteGroup )
     {
       warn("remoteGroup = ",Dumper($remoteGroup)) if $dbg ;
       $remoteGroup = &createDummyGroup($group) ;
       $remoteGroup{$group} = $remoteGroup  ; # Save in assoc array
     }
     else {
       return undef;
     }
   }

   return $remoteGroup;
}
