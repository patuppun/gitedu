#!/usr/local/bin/perl
use strict;
use Cwd;

my $path = cwd();
while ($path) {
   last if (-e "$path/.git");
   $path = `dirname $path`;
   chomp($path);

   if ($path eq '/') {
      print "Error: Not a git repository.\n";
      exit 1;
   }
}

foreach my $hook (qw(commit-msg prepare-commit-msg)) {
   unless (-e "$path/.git/hooks/$hook") {
      print "Creating client-side hook '$hook'...\n";

      system("cp /projects/ccxsw_tools/contrib/git/hooks/$hook $path/.git/hooks/");

      # check for the new hook
      unless (-e "$path/.git/hooks/$hook") {
         print "Error: could not create client-side hook '$hook'.\n";
      }
   }
}

my @remotes = `git remote -v`;
foreach my $remote (@remotes) {
   if ($remote =~ /origin\s+svcccxswgit\@.*?:(.*?) \(push\)/) {
      print "Setting Gerrit remote push url...\n";
      system("git remote set-url --push origin ssh://gerrit-ccxsw.rtp.broadcom.com:29418/$1");
   }
}

