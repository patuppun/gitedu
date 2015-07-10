#!/usr/local/bin/perl
# usage:
# perl create_project.pl --source ctrl=ctrl.json --project Controller --key CTRL
# perl create_project.pl --source rtpjira=wlan.json --project WLAN --key WLAN
# perl create_project.pl --source engjira=avb_engjira.json --project AVB --key AVB

use strict;
use Getopt::Long;
use Data::Dumper;
use Config::IniFiles;
use JSON;
use REST::Client;
use MIME::Base64;
use File::Path;
use FindBin qw($Bin $Script);
#use lib "$Bin/lib";
use URI::Escape;
use Date::Manip;

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my $max = 0;
my $start_id = '';
my @sources = ();
my $encode = 0;
my $username = '';
my $filter = '';
my $server = 'jira-ccxsw.rtp.broadcom.com:8080';
my $attachment_path = "/projects/ccxsw_jira/production/jirahome/import/attachments";
my $timezone = "America/New_York";

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }
sub convert($) {
   my ($text) = @_;

   #   Map incompatible CP-1252 characters
   $text =~ s/\x82/,/g;
   $text =~ s-\x83-<em>f</em>-g;
   $text =~ s/\x84/,,/g;
   $text =~ s/\x85/.../g;
   
   $text =~ s/\x88/^/g;
   $text =~ s-\x89- °/°°-g;
   
   $text =~ s/\x8B/</g;
   $text =~ s/\x8C/Oe/g;
   
   $text =~ s/\x91/'/g;
   $text =~ s/\x92/'/g;
   $text =~ s/\x93/"/g;
   $text =~ s/\x94/"/g;
   $text =~ s/\x95/*/g;
   $text =~ s/\x96/-/g;
   $text =~ s/\x97/--/g;
   $text =~ s-\x98-<sup>~</sup>-g;
   $text =~ s-\x99-<sup>TM</sup>-g;
   
   $text =~ s/\x9B/>/g;
   $text =~ s/\x9C/oe/g;
   
   $text =~ s/[^[:ascii:]]//g;
   
   return $text;
}


GetOptions('debug'     => \$debug,
           'max=n'     => \$max,
           'start=s'   => \$start_id,
           'source=s'  => \@sources,
           'filter=s'  => \$filter,
           'server=s'  => \$server,
           'tz=s'      => \$timezone,
           );

my $usage = "Usage: $Script --source \"<type>=file name\" [--debug] [--max <n>] .";

unless (@sources) {
   msg("$usage\n\tAt least one source must be specified.\n");
   exit 1;
}

Date_Init("TZ=$timezone");

msg("TZ=",Date_TimeZone(),"\n");

$filter = uri_escape($filter) if ($filter);

my ( $user, $password ) = &login($username);

# determine custom field name mapping
msg("Fetching custom fields..\n");
my $fields = &run_query('GET', 'field');
my %field_map;
my %field_name_map;

foreach my $field (@{$fields}) {
   $field_map{$field->{id}} = $field;
   $field_name_map{lc($field->{name})} = $field->{id};
}

# fetch current fields
msg("Fetching issue ID mapping..\n");
my $issues = &query_issues($filter, 'Project','key','Summary','Legacy Issue #','Reporter','Updated');
debug(Dumper($issues));

my %new_keys = map {$_->{'Legacy Issue #'} => $_} @{$issues};

debug(Dumper(\%new_keys));

print "Project Key,Project Name,issue key,Summary,Updated,Attachment\n";
my $count = 0;
my $attachments = 0;
my $attachment_issues = 0;
foreach my $source (@sources) {
   my ($type, $file) = split('=', $source, 2);

   msg("Source: $file ($type)\n");

   $type = lc($type);

   unless (-e $file) {
      msg("Source file not found.\n");
      exit 1;
   }

   msg("Loading source file: $file.\n");
   my $source_text = `cat $file`;
   unless ($source_text) {
      msg("Source file could not be loaded.\n");
      exit 1;
   }
   msg("Decoding source file...\n");
   my $source_issues = $encode ? decode_json($source_text) : from_json($source_text);

   msg("Processing ", scalar(@{$source_issues}), " issues...\n");

   foreach my $src_issue (@$source_issues) {
      my $issue_id = ($type eq 'cq') ? $src_issue->{id} : $src_issue->{key};

      # skip to a specific issue
      next if ($start_id && $issue_id ne $start_id);
      $start_id = '';

      my $project_key = $new_keys{$issue_id}->{Project}->{key};
      my $project_name = $new_keys{$issue_id}->{Project}->{name};
      my $new_id = $new_keys{$issue_id}->{key};
      unless ($new_id) {
         msg("Unknown id: $issue_id\n");
         next;
      }
      my $summary = convert($new_keys{$issue_id}->{Summary});
      $summary =~ s/\"/\"\"/gs;

      my $updated_date = ParseDate($new_keys{$issue_id}->{Updated});
      my $updated_datestr = '';
      if ($updated_date) {
         $updated_datestr = UnixDate($updated_date, "%d/%b/%y %i:%M %p");
         $updated_datestr =~ s/  / /g;
      }
      else {
         msg("Unknown date format for $issue_id: $new_keys{$issue_id}->{Updated}\n");
      }



#      print Dumper($src_issue);

      my $path;
      if ($issue_id =~ /^(.*?)-(\d{2})/ || $issue_id =~ /^(.*?)-(\d{1})/ || $issue_id =~ /^(.*?)0+(\d{2})/) {
         $path = "$1/$2/$issue_id";
      }

      unless ($path) {
         msg("Unknown id format: $issue_id\n");
         exit;
      }

      my @attachments = ();

      if ($type eq 'cq') {
         my $author = $new_keys{$issue_id}->{Reporter}->{name};
         my $date_val = $src_issue->{Submit_Date};
         my $date = ParseDate($src_issue->{Submit_Date});
         next unless ($date);

#         print "$src_issue->{Submit_Date}\n";
         my $datestr = UnixDate($date, "%d/%b/%y %i:%M %p");
         $datestr =~ s/  / /g;

         $attachment_issues++ if (@{$src_issue->{Attachments}});
         foreach my $attachment (@{$src_issue->{Attachments}}) {
            my $filename = convert($attachment->{filename});

            my $url = "file://$path/".uri_escape($filename);
            push @attachments, "$datestr;$author;$filename;$url";
         }
      }
      else {
         $attachment_issues++ if (@{$src_issue->{Attachment}});
         foreach my $attachment (@{$src_issue->{Attachment}}) {
            my $author = $attachment->{author}->{name};
            my $created = $attachment->{created};
#            print "$created\n";
            my $date = ParseDate($attachment->{created});
            next unless ($date);

            my $datestr = UnixDate($date, "%d/%b/%y %i:%M %p");
            $datestr =~ s/  / /g;

            my $filename = convert($attachment->{filename});

            unless (-e "$attachment_path/$path/$filename") {
               msg("Unknown attachmeht: $path/$filename\n");
               next;
            }
            my $url = "file://$path/".uri_escape($filename);
            push @attachments, "$datestr;$author;$filename;$url";
         }
      }

      foreach my $attachment (@attachments) {
         print convert("$project_key,$project_name,$new_id,\"$summary\",\"$updated_datestr\",\"$attachment\"\n");
         $attachments++;
      }

      $count++;
      last if ($max && $count > $max);
   }
}
msg("$attachments attachments.\n");
msg("$attachment_issues issues.\n");

sub login {
    use Term::ReadKey;
    my ($user, $password) = @_;

    unless ($user) {
       if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
          foreach my $line (<NETRC>) {
             chomp($line);
             if ($line =~ /^machine jira login (.*?) password (.*?)$/) {
                $user = $1;
                $password = $2;
                last;
             }
          }
          close(NETRC);
       }
    }

    until ($user) {
       print STDERR "Username: ";
       $user = ReadLine(0);
    }

    until ($password) {
        print STDERR "Password: ";
        ReadMode('noecho');
        $password = ReadLine(0);
        ReadMode('normal');
        print STDERR "\n";
    }
    chomp($user);
    chomp($password);

    return ( $user, $password );
}

sub run_query($$) {
   my ($cmd, $query, $api) = @_;
   $api ||= '/rest/api/2';
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
   my $client = REST::Client->new();
   $client->setHost("http://$server");
   debug(">$cmd $api/$query\n");
   if (uc($cmd) eq 'GET') {
      $client->GET("$api/$query", $headers);
   }
   elsif (uc($cmd) eq 'SET') {
      $client->SET("$api/$query", $headers);
   }
   elsif (uc($cmd) eq 'POST') {
      $client->POST("$api/$query", $headers);
   }
   elsif (uc($cmd) eq 'DELETE') {
      $client->DELETE("$api/$query", $headers);
   }
   else {
      print "No command entered.\n";
      exit 1;
   }
   if ($client->responseCode()==200) {
      debug(Dumper($client->responseContent()));
      my $response = from_json($client->responseContent());
      debug(Dumper($response));
      return $response;
   }
   else {
      msg($client->responseContent());
      return undef;
   }
}

sub query_issues {
   my ($query,@fields) = @_;

   my @issues = ();
   my $fields = (join(',', (map {$field_name_map{lc($_)}} @fields)) || '*all');

   my $startAt = 0;
   my $maxResults = 1000;
   my $done = 0;

   my $starttime = time();
   while (!$done) {
      $issues = &run_query('GET', "search?jql=$query&startAt=$startAt&maxResults=$maxResults&fields=$fields");
      $startAt += $maxResults;
      if ($issues) {
         foreach my $issue (@{$issues->{issues}}) {
            my %new_issue = (key => $issue->{key});
            foreach my $field (keys(%{$issue->{fields}})) {
               $new_issue{$field_map{$field}->{name}} = $issue->{fields}->{$field};
            }
            push @issues, \%new_issue;

         }
         msg("$startAt...\n");

         $done = 1 if (($issues->{startAt} + $issues->{maxResults}) > $issues->{total});
      }
      else {
         $done = 1;
      }
   }

   msg("Retrieved ", scalar(@issues), " records.\n");
   msg("   Start:        ", scalar(localtime($starttime)), "\n");
   msg("   End:          ", scalar(localtime()), "\n");
   msg("   Duration:     ", time() - $starttime, "\n");
   msg("   Seconds Each: ", sprintf("%0.3f", (time() - $starttime)/scalar(@issues)), "\n");

   return \@issues;
}
