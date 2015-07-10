#!/usr/local/bin/perl

use strict;
use Getopt::Long;
use XML::XPath;
use File::Temp qw/ tempfile tempdir tmpnam cleanup /;
use File::Path qw(mkpath);
use File::Basename;
use Data::Dumper;
use JSON;

$| = 1;

# ignore _JAVA_OPTIONS
delete($ENV{_JAVA_OPTIONS});

my $tools_dir;

BEGIN {
        my $script = $0;
        $script =~ s/\\/\//g;  #convert back to forward slashes to support Windows

        if ($script =~ /^(.*?\/)bin\//) {
           $tools_dir = "$1/contrib";
        }
        elsif ($script =~ /^(.*?\/contrib)\// || 
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
        #print STDERR "Tools Dir: $tools_dir\n";
}

use lib "$tools_dir/perllib";

use CodeCollaborator;   # Pulling in %reviewable_extension_whitelist and %reviewable_filename_whitelist hashes

my $add_diffs = 0;  # turns on code to add deltas manually in the case of files that don't show up in /main views
my $debug = 0;

sub windows {($^O =~ /cygwin/i || $^O =~ /win32/i);}
sub msg(@) { print STDERR scalar(localtime()), ": ", @_; }
sub debug(@) { msg(@_) if ($debug); }
sub run(@) { debug(">",@_,"\n"); system(@_); }
sub cat(@) { debug(">",@_,"\n"); return wantarray() ? `@_` : scalar(`@_`); }

sub branchname { 
   my @branches = `git branch`;
   chomp(@branches);
   my $active_branch = (grep {$_ =~ /^\*/} @branches)[0];
   $active_branch =~ s/^\*\s*//;
   return $active_branch;
}


$ENV{CYGWIN} = "nodosfilewarning" if (windows());

my $usage = "submitreview.pl [options]\n";

my $ccollab = "ccollab";
my $review = 0;
my $summary = '';
my $task = '';
my $help = 0;
my $test = 0;

my $usage = "Usage: submitreview.pl [--summary <review summary>] [--task <JIRA-#### task number>] <base> [current]";

GetOptions('help|?' => \$help,
           'debug'     => \$debug,
           'review=n'  => \$review,
           'summary=s' => \$summary,
           'task=s' => \$task,
           'test' => \$test,
           );

if ($help) {
   print "$usage\n";
   exit;
}

my $base = shift(@ARGV);
unless ($base) {
   print "$usage\nMust specify the base commit/branch.\n";
   exit 1;
}
my $current = shift(@ARGV);

my $branch = $current || branchname();
unless ($task) {
   if ($branch =~ /^bug\/(.*?)$/) {
      $task = uc($1);
   }
   elsif ($branch =~ /^task_(.*?)_(\d*?)$/) {
      $task = uc($1).'-'.$2;
   }
   elsif ($branch =~ /^task_(\d*?)$/) {
      my $tasknum = $1;

      my $repo = '';
      my @remotes = `git remote -v`;
      foreach my $remote (@remotes) {
         if ($remote =~ /origin.*:(.*?) \(push\)/) {
            $repo = uc($1);
            last;
         }
      }
      unless ($repo) {
         print "Error: unknown origin repo.\n";
         exit 1;
      }
      $task = uc($repo)."-$tasknum";
   }
}

if ($task && !$summary) {
   if ($task =~ /^(\w*?)-(\d*?)/) {
      my $project = $1;
      my $tasknum = $2;

      my $server = 'jira-rtp-04.rtp.broadcom.com:8080';
      my $username = 'querier';
      my $password = 'ccxquerier';

      if (uc($project) eq 'FP') {
         $server = 'jirartp.rtp.broadcom.com:8080';
         $password = 'lvl7querier';
      }

      my $response = `perl $tools_dir/jira/query_jql.pl --json --username $username --password $password --query \"id=$task\"`;
      my $response = from_json($response);
      print Dumper($response) if ($debug);
      $summary = $response->[0]->{Summary};
   }
}

if ($task && !$review) {
   # search for an open review for this task branch
   my @reviews = `$ccollab admin wget "/go?page=ReportReviewList&formSubmittedreportConfig=1&phaseFilter=inprogress&reviewIdVis=y&reviewTitleVis=y&data-format=csv" 2>&1`;
   foreach my $line (@reviews) {
      if ( ($line =~ /^(\d*),"*CCXSW $task:/) || ($line =~ /^(\d*),"*CCXSW .*\($task\)/) ) {
         $review = $1;
         last;
      }
   }
}

print "Defect:          $task\n" if ($task);
print "Base Commit:     $base\n";
print "Current Commit:  $branch\n";
print "Summary:         $summary\n" if ($summary);
print "Review:          $review\n" if ($review);

my $processed_summary = $summary;
if (windows()) {
   $processed_summary =~ s/\"/\'/g;  # Current ccollab cannot handle nested escaped double quotes
} else {
   $processed_summary =~ s/\"/\\\"/g;
}

# Create the review if necessary
unless ($review || $test) {
   my $jira_link = "http://jira-ccxsw.rtp.broadcom.com:8080/browse/" . $task;
   print "Creating review...\n";

   my $cmd = "$ccollab --no-browser admin review create";
   $cmd .= $task ? " --title \"CCXSW $task: $processed_summary\" --custom-field \"Overview=$jira_link\n\nBranch: $base\"" : " --title \"CCXSW: $processed_summary\"";
   $cmd .= " --display-changelists-as \"single\"";
   my $result = &cat("$cmd 2>&1");

   &debug("Result:\n$result\n");
   if ($result =~ /Review \#(\d+):/s) {
      $review = $1;
      print "Created review #$review.\n";
   }
   else {
      print "*** Could not create review.\n";
      exit 1;
   }
#   if ($result =~ /Connected as (.*?) \((.*?)\)/s) {
#      my $user = $1;
#      my $username = $2;
#       
#      # set author
#      print "Setting author to: $user ($username)...\n";
#      my $cmd = "$ccollab --no-browser admin review set-participants $review --set-participant author=$username";
#      my $result = &cat("$cmd 2>&1");
#   }
}
# determine which commits are in the current branch
print "Finding all changes up to $branch...\n";
my @branch_revs = `git rev-list --first-parent HEAD`;
chomp(@branch_revs);
print map {"branch: $_\n"} @branch_revs if ($debug);

my @base_revs = `git rev-list --first-parent $base`;
chomp(@base_revs);
my %base_revs = map {$_ => 1} @base_revs;
print map {"base: $_\n"} @base_revs if ($debug);

my @review_revs;
my $branch_base;

# iterate through history of the branch
foreach my $sha (@branch_revs) {
   my $parents = `git rev-list --parents -n 1 $sha`;
   my ($left, $right);
   if ($parents =~ /^(.*?) (.*?)$/ || $parents =~ /^(.*?) (.*?) (.*?)$/) {
      $left = $2;
      $right = $3;
   }
   print "$parents:\n" if ($debug);

   push @review_revs, $sha;
   # did the branch branch off of the base?
   if (defined($base_revs{$sha})) {
      $branch_base = $sha;
      last;
   }
   # did the branch merge from the base?
   elsif (defined($base_revs{$left})) {
      $branch_base = $left;
      push @review_revs, $left;
      last;
   }
   elsif (defined($base_revs{$right})) {
      $branch_base = $right;
      push @review_revs, $right;
      last;
   }
}

unless ($branch_base)
{
   print "Branch ($branch) is not on the same tree as $base.\n";
   exit 1;
}
print map {"$_\n"} @review_revs if ($debug);

my $branch_base_short = &short_commit($branch_base);
print "Base Revision:   $branch_base ($branch_base_short)\n";

my $latest_rev = $review_revs[0];
my $latest_rev_short = &short_commit($latest_rev);

print "Latest Revision: $latest_rev ($latest_rev_short)\n";

# determine which commits have been submitted to the review
print "Finding previous changes submitted to review \#$review...\n";
my $xml = `ccollab admin review-xml $review --xpath \"//reviews/review/custom-review-fields"`;
print "$xml\n" if ($debug);

my $nodeset = XML::XPath->new(xml => $xml);
my $overview = $nodeset->findvalue('//overview') || '';
my $last_commit = 'N/A';
if ($overview =~ /Last-Commit: (\w*)/m) {
   $last_commit = $1;
}
print "Last Commit:     $last_commit (", &short_commit($last_commit), ")\n";
$last_commit = '' if ($last_commit eq 'N/A');

#my $nodeset = $artifacts->find('/artifacts'); # find all artifacts
#foreach my $node ($nodeset->get_nodelist) {
#  my $previous = $artifacts->findvalue('//prev-scmVersion', $node);
#  my $version = $artifacts->findvalue('//scmVersion', $node);
#  print "FOUND:  $previous .. $version\n";
#}

my @submit_order = reverse(@review_revs);

# remove commits that have already been submitted for review
if ($last_commit) {
   while (@submit_order) {
      last if ($submit_order[0] eq $last_commit);
      shift(@submit_order);
   }
}

# first commit is the base to submit for review
my $start = shift(@submit_order);
if (@submit_order) {
   # remaining commits are the next commits to diff
   print "To Submit: @submit_order\n" if ($debug);

   my $comment = join("\n\n", map {"$_:\n".&get_headline($_)} @submit_order);
   # escape all quotes
   $comment =~ s/\"/\\\"/gs;

   my $end = $submit_order[-1];

   print "Submitting change ", &short_commit($start), "..", &short_commit($end), " to review $review:\n$comment\n";
   my $result = &cat("$ccollab addgitdiffs --upload-comment \"$comment\" $review $start $end --no-ext-diff --no-prefix 2>&1");
   &debug("Result:\n$result\n");

   if ($overview =~ /$start/) {
      $overview =~ s/$start/$end/gs;
   }
   else {
      $overview = ($overview ? "$overview\n" : "") . "Last-Commit: $end";
   }

   my $result = &cat("$ccollab admin review edit $review --custom-field \"Overview=$overview\" 2>&1");
   &debug("Result:\n$result\n");

#   foreach my $next (@submit_order) {
#      print "Submitting change $prev..$next to review $review...\n";
#      my $headline = &get_headline($next);
#      #&run("git --no-pager diff --name-status $base $branch");
#   #   my $result = &cat("$ccollab addgitdiffs --upload-comment \"$headline\" $review $branch_base_ref $branch --no-ext-diff --no-prefix");
#      my $result = &cat("$ccollab addgitdiffs --upload-comment \"$next: $headline\" $review $prev $next --no-ext-diff --no-prefix");
#      &debug("Result:\n$result\n");
#      $prev = $next;
#   }

   print "Calling browser summary and exiting.\n";
   `$ccollab browse --review $review 2>&1`;
}
else {
   print "No more changes to submit.\n";
}

sub get_headline() {
   my ($commit) = @_;
   # find headline for  commit
   my @show = `git show --oneline $commit`;
   chomp(@show);
   my $headline = $show[0];
   $headline =~ s/^.*? //;
   print "Commit Message:  $headline\n" if ($debug);
   return $headline;
}

sub short_commit() {
   my ($commit) = @_;

   return substr($commit, 0, 7);
}
