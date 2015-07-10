#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings;
use Data::Dumper;
use strict;

# Get the CGI data and extract the fields
my $query = new CGI;
print $query->header("text/html");

my $debug = CGI::param('debug');
my $site = CGI::param('site');
my $repo = CGI::param('repo');

my $branch = CGI::param('branch') || '';
$branch = '' if ($branch eq 'Invalid');

my $tag = CGI::param('tag') || '';
$tag = '' if ($tag eq 'Invalid');

my $change = CGI::param('change') || '';
$change = '' if ($change eq 'Invalid');

# clean up change to be the correct format
if ($change =~ /^(.*?):/) {
   # remove change comment if present
   $change = $1;
}

if ($change =~ /^\d*(\d\d)\/\d*/) {
   $change = "$1/$change";
}

$change = "refs/changes/$change" if ($change);

my $baseline = $tag || $change || $branch;
exit unless ($baseline);

my $type = CGI::param('type') || 'builds';
my $package = CGI::param('package') || '';

use ElectricCommander;
my $username = '';
if (defined($ENV{COMMANDER_SERVER})) {
   my $ec = ElectricCommander->new();
   $ec->abortOnError(0);
   $username = $ec->getProperty("/myUser/userName")->findvalue("//value");
}

my @buildlist_ini = &remote_file($site, $repo, $baseline, 'buildlist.ini');
@buildlist_ini = &remote_file($site, $repo, 'master', 'buildlist.ini') unless (@buildlist_ini);
my %cfg = &parse_inifile(@buildlist_ini);

#create package hash for each package
my %packages = map {$_ => {}} grep {$_} keys(%{$cfg{packages} || {}});

#parse out builds for each package
foreach my $p (keys(%packages)) {
   my @package_builds = split(',', $cfg{packages}->{$p});
   map {$packages{$p}->{$_} = 1} @package_builds;
}

#find unique set of builds
my @builds = sort(grep {$_ ne 'packages' && $_ ne 'builds' && $_ ne 'default' && $_ ne 'delivery'} keys(%cfg));

# support [builds] section
push @builds, keys(%{$cfg{builds}}) if (defined($cfg{builds}));

if ($type eq 'package') {
   print "\n" if (scalar(keys(%packages)) == 1);
   print map {"$_\n"} keys(%packages);
}
else {
   my @build_data;
   foreach my $build (@builds) {
      my $selected = 'false';

      if ($package && $packages{$package} && $packages{$package}->{$build}) {
         $selected = 'true';
      }

      push @build_data, "$build,$selected,false";
   }
   print map {"$_\n"} (@build_data ? sort(@build_data) : "all,true");
}
 
exit ( 0 ) ;

sub remote_file() {
   my ($site, $repo, $baseline, $file) = @_;
   my $cmd = "ssh svcccxswgit\@git-ccxsw.$site.broadcom.com 'git --git-dir=/home/svcccxswgit/repositories/$repo.git show $baseline:$file'";
   print "> $cmd\n" if ($debug);
   my @data = `$cmd 2>&1`;
   chomp(@data);
   
   my $header = 1;
   my @out_data;
   foreach my $line (@data) {
      next if ($header && $line =~ /^[+|]/);
      $header = 0;
      push @out_data, $line;
   }
   return @out_data;
}

sub parse_inifile(@) {
   my (@lines) = @_;
   my %ini;
   my $section;
   foreach my $line (@lines) {
      next if ($line =~ /^\s*#/ || $line =~ /^\s*$/);
      if ($line =~ /^(.*?)=(.*?)$/) {
         $ini{$section}->{$1} = defined($ini{$section}->{$1}) ? "$ini{$section}->{$1}\n$2" : $2;
      }
      if ($line =~ /^\s*\[(.*?)\]\s*$/) {
         $section = $1;
         $ini{$section} ||= {};
      }
   }
   return %ini;
}

