#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings;
use Data::Dumper;
use strict;

my $deliverables = "/projects/ccxsw_tools/deliverables";
my $releases = "/projects/ccxsw_rel/deliverables";

# Get the CGI data and extract the fields
my $query = new CGI;
print $query->header("text/html");

my $baseline = CGI::param('branch');
my $build = CGI::param('build') || 'firmware';

my $tag_prefix = uc($baseline);

if ($tag_prefix =~ /^(.*?)\.X/) {
   $tag_prefix = $1;
}

use ElectricCommander;
my $username = '';
if (defined($ENV{COMMANDER_SERVER})) {
   my $ec = ElectricCommander->new();
   $ec->abortOnError(0);
   $username = $ec->getProperty("/myUser/userName")->findvalue("//value");
}

my $repo = $build eq 'firmware' ? 'client_security_firmware' : 'client_security_host';

if (opendir(DIR, "$deliverables/$repo/")) {
   foreach my $dir (reverse(sort(readdir(DIR)))) {
      next if ($dir =~ /^\./);
      if ($dir =~ /[0-9]*?_$tag_prefix/ && opendir(SUBDIR, "$deliverables/$repo/$dir/$build")) {
         my @files = grep {$_ !~ /^\./} readdir(SUBDIR);
         print "$dir\n" if (@files);
      }
   }
}

exit ( 0 ) ;

sub remote_file() {
   my ($site, $repo, $baseline, $file) = @_;
   my @data = `ssh svcccxswgit\@git-ccxsw.$site.broadcom.com 'git --git-dir=/home/svcccxswgit/repositories/$repo.git show $baseline:$file' 2>&1`;
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
