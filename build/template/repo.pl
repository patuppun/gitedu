#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings ;
 
# Get the CGI data and extract the fields
my $query = new CGI;
print $query->header("text/html");
 
use ElectricCommander;
my $username = '';
if (defined($ENV{COMMANDER_SERVER})) {
   my $ec = ElectricCommander->new();
   $ec->abortOnError(0);

   my $userProperty = '';
   if($ENV{'COMMANDER_JOBSTEPID'}) {
     $userProperty = '/myJob/launchedByUser';
   }
   else {
     $userProperty = '/myUser/userName';
   }
   $username = $ec->getProperty($userProperty)->findvalue('//value')->value();
}
else
{
   $username = lc(CGI::param('user'));
}

my $site = lc(CGI::param('site')) || 'rtp';
my @repos = &remote_command('rtp', 'list-repos');
@repos = grep {$_ && $_ !~ /^\@/ && $_ ne 'gitolite-admin' && $_ ne 'tools'} @repos;
print map {"$_\n"} @repos;
#foreach my $repo (@repos) {
#   my @access = &remote_gitolite($site,"access $repo $username R");
#   if (@access && $access[0] !~ /DENIED/) {
#      print "$repo\n";
#   }
#}
exit ( 0 ) ;

sub remote_command() {
   my ($site, $cmd) = @_;
   my $ssh_cmd = "ssh svcccxswgit\@git-ccxsw.$site.broadcom.com '$cmd'";
   my @data = `$ssh_cmd 2>&1`;
   chomp(@data);
   @data = grep {$_ !~ /^[+|]/} @data;
   return @data;
}
