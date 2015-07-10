#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings;
use JSON;
use Data::Dumper;

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

# Get the CGI data and extract the fields
my $query = new CGI;
 
print $query->header("text/html");
 
my $site = CGI::param('site');
my $repo = CGI::param('repo') || '';
my $branch = CGI::param('branch') || '';
my $type = CGI::param('type') || 'heads';
my $debug = CGI::param('debug') || 0;

if ($debug) {
   print "site=$site\n";
   print "repo=$repo\n";
   print "branch=$branch\n";
   print "type=$type\n";
}

if ($repo)
{
        #my @branches = `git ls-remote --heads --tags ssh://svcccxswgit\@git-ccxsw.$site.broadcom.com/$repo 2>&1`;
        my @branches = `ssh -p 29418 gerrit-ccxsw.rtp.broadcom.com 'gerrit ls-user-refs --project \"$repo\" --user \"$username\"' 2>&1`;
        chomp(@branches);

        my @branch_list;
        if ($type eq 'changes') {
           my @changes_json = `ssh -p 29418 gerrit-ccxsw.rtp.broadcom.com 'gerrit query --format json --current-patch-set \"project:$repo branch:$branch\"'`;

           foreach my $change_json (@changes_json) {
              my $change = from_json($change_json);
              print Dumper($change, {pretty=>1}) if ($debug);


              next unless (defined($change->{number}));
              my $change_num = $change->{number};
              my $patches = $change->{currentPatchSet}->{number};
              my $subject = $change->{subject};
              foreach my $r (1..$patches) {
                 my $revision = $patches-$r+1;
                 push @branch_list, "$change_num/$revision: $subject";
              }
           }
        }
        else {
           foreach my $branch (@branches) {
              if ($branch =~ /refs\/$type\/(.*?)$/) {
                 $branch = $1;

   #              if ($type eq 'changes') {
   #                 if ($branch =~ /^(.*?)\/(.*?)\/(.*?)$/) {
   #                    $branch = "$2/$3";
   #                 }
   #              }
                 push @branch_list, $branch;
              }
           }
           @branch_list = sort(@branch_list);
        }
        unshift @branch_list, '' if (scalar(@branch_list) == 1);
	print map {"$_\n"} @branch_list;
}
else
{
	print "\n";
} 
exit ( 0 ) ;
