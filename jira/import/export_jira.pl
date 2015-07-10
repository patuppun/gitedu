#!/usr/bin/perl
# usage:
# perl export_jira.pl --server rtpjira.rtp.broadcom.com:8080 --query 14155 --user cpverne --max 1 --nfeed nfeed_values.csv --file rtpjira_ids.txt
# perl export_jira.pl --server engjira.sj.broadcom.com:8080 --query 21985

use strict;
use Getopt::Long;
use REST::Client;
use MIME::Base64;
use Data::Dumper;
use JSON;
use File::Path qw(make_path);
use URI::Escape;

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my $server = '';
my @queries = ();
my $username = '';
my $max = 0;
my $start = 0;
my $start_at = '';
my $pretty = 1;
my $encode = 0;
my $attachments = 1;

my $attachment_path = '/projects/ccxsw_jira/production/jirahome/import/attachments';

my @ids = ();
my $ids_file = '';
my $nfeed_file = '';
my @sets = ();

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
   $text =~ s/\x98/~/g;
   $text =~ s/\x99/'/g;
   
   $text =~ s/\x9B/>/g;
   $text =~ s/\x9C/oe/g;
   
   $text =~ s/[^[:ascii:]]//g;
   
   # convert escaped \n to actual endline
   $text =~ s/\\n/\n/g;

   return $text;
}

GetOptions('debug'        => \$debug,
           'server=s'     => \$server,
           'query=s'      => \@queries,
           'id=s'         => \@ids,
           'idsfile=s'    => \$ids_file,
           'nfeed=s'      => \$nfeed_file,
           'max=n'        => \$max,
           'start=n'      => \$start,
           'startat=s'    => \$start_at,
           'pretty'       => \$pretty,
           'encode!'      => \$encode,
           'user=s'       => \$username,
           'attachments!' => \$attachments,
           'set=s'        => \@sets,
           );

my $usage = "Usage: export_jira.pl --server <server> [--id <id> ...] [--id_file <input/output file>]";

unless ($server) {
   msg("$usage\n\tserver must be specified.\n");
   exit 1;
}

my %sets = ();
foreach my $set (@sets) {
   my ($field, $value) = split('=', $set, 2);
   next unless ($field);
   $sets{$field} = $value;
}

my ( $user, $password ) = &login($username);

# set up query to get issues.	
my $src_headers = { 'Content-Type' => 'application/json',        
                    Authorization  => 'Basic ' . encode_base64($user . ':' . $password),
                  };

if (-e $ids_file) {
   my %id_hash;
   if (open(FILE, "<$ids_file")) {
      foreach my $line (<FILE>) {
         next if $line =~ /^#/;
         chomp($line);

         $id_hash{$line} = 1;
      }
   }
   push @ids, sort(keys(%id_hash));

   unless (scalar(@ids)) {
      &msg("No ids found in file: $ids_file\n");
      exit 1;
   }
   &msg("Loaded ", scalar(@ids), " records (last: $ids[-1]).\n");
}

if (@ids) {
   push @queries, join('||', map {"id=$_"} @ids);
}


# determine custom field name mapping
my $fields = &run_query('field');
my %field_map;
my %field_name_map;

foreach my $field (@{$fields}) {
   $field_map{$field->{id}} = $field;
   $field_name_map{lc($field->{name})} = $field->{id};
}

my %nfeed_values = ();
# load field values
if (open(FILE, "<$nfeed_file")) {
   foreach my $line (<FILE>) {
      chomp($line);
      my ($key, $value) = split(',', $line, 2);
      $nfeed_values{$key} = $value;
   }
}

my %nfeed_fields = map {$_ => 1} ('Platforms Affected', 'Customer Name', 'Platform Found On', 'Platform');

print '[', $pretty ? "\n" : '';

foreach my $query (@queries) {
   if ($query =~ /^\d+$/) {
      # fetch the JQL from JIRA for this filter ID
      msg("Loading query $server -> $query...\n");
      my $filter = &run_query("filter/$query");
      if ($filter) {
         $query = $filter->{searchUrl};
         $query =~ s/^.*?jql=//;
      }
      else {
         msg("Can't fetch filter.\n");
         exit 1;
      }
   }

   # determine number of issues.
   my $issues = &run_query("search?jql=$query&startAt=0&maxResults=0");
   unless ($issues) {
      msg("Could not run query: $query\n");
      exit 1;
   }
   my $total = $issues->{'total'};
   msg("Total issues: $total\n");

   my @issues = ();

   my $startAt = 0;
   my $maxResults = 1000;
   my $done = 0;

   my $starttime = time();
   while (!$done) {
      $issues = &run_query("search?jql=$query&startAt=$startAt&maxResults=$maxResults&fields=*all");
      $startAt += $maxResults;
      if ($issues) {
         push @issues, @{$issues->{issues}};
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

   msg("Processing records...\n");
   $starttime = time();
   my $count = 0;
   foreach my $issue (@issues) {
      if ($start_at) {
         if ($start_at eq $issue->{key}) {
            $start_at = '';
         }
         else {
            next;
         }
      }

      if ($start && $count < $start) {
         $count++;
         next;
      }

      debug(Dumper($issue));

      my %values = (key => $issue->{key});
      foreach my $field (sort(keys(%{$issue->{fields}}))) {
         next unless (defined($field_map{$field}->{name}));
#            msg("Unknown field: $field -> $issue->{fields}->{$field}\n");
#            next;
#         }
         my $field_name = $field_map{$field}->{name} || $field;
         my $field_schema = $field_map{$field}->{schema} || {};
         next if ($field_name =~ /^_/);
         my $field_value = $issue->{fields}->{$field};

         if (!defined($field_value)) {
            $field_value = '';
         }
         else {
            # break values out of array of hashes
            if ($field_name eq 'Fix Version/s' ||
                $field_name eq 'Affects Version/s' ||
                $field_name eq 'Planned-version' ||
                $field_name eq 'Component/s') {
               $field_value = [map {$_->{name}} @{$field_value}];
            }
            elsif ($field_name eq 'Chips') {
               $field_value = [map {$_->{value}} @{$field_value}];
            }

            if (ref($field_value) eq "HASH") {
               if (defined($field_value->{value})) {
                  $field_value = $field_value->{value};
               }
               elsif (defined($field_value->{name})) {
                  $field_value = $field_value->{name};
               }
               elsif ($field eq 'aggregateprogress' || $field eq 'progress') {
                  $field_value = "Progress = $field_value->{progress}, Total = $field_value->{total}";
               }
               elsif ($field eq 'comment') {
                  $field_value = $field_value->{comments};
               }
               elsif ($field eq 'watches') {
                  $field_value = '';
               }
               elsif ($field eq 'timetracking') {
                  $field_value = '';
               }
               elsif ($field eq 'worklog') {
                  $field_value = '';
               }
               else
               {
                  msg("Unknown field value for $field ($field_name):\n", Dumper($field_value));
                  exit 1;
               }
            }
            elsif ($field =~ /^customfield_/) {
               if (defined($nfeed_fields{$field_name})) {
                  debug("$field_name:\n ", Dumper($field_value), "\n");
                  if (ref($field_value) eq 'ARRAY') {
                     my @nfeed_values = ();
                     foreach my $val (@{$field_value}) {
                        if (defined($nfeed_values{$val})) {
                           push @nfeed_values, $nfeed_values{$val};
                        }
                        else {
                           msg("Error: could not dereference nfeed value: $val for field $field_name\n");
                           exit 1;
                        }
                     }
                     debug(Dumper(\@nfeed_values), "\n");
                     $field_value = \@nfeed_values;
                  }
                  else {
                     if (defined($nfeed_values{$field_value})) {
                        $field_value = $nfeed_values{$field_value};
                     }
                     else {
                        msg("Error: could not dereference nfeed value: $field_value for field $field_name\n");
                        exit 1;
                     }
                  }
               }
            }
         }

         # verify no remaining hash field values
         if (ref($field_value) eq "HASH") {
            msg("Unmapped value: $field_name\n", Dumper($field_value));
            exit 1;
         }
         unless (ref($field_value)) {
            $field_value = convert($field_value);
         }
         $values{$field_name} = $field_value;
      }

      foreach my $field (keys(%sets)) {
         $values{$field} = $sets{$field};
      }

      debug(Dumper(\%values));
      $count++;

      print ",", $pretty ? "\n" : '' if ($count > 1);
      if ($encode) {
         print encode_json(\%values);
      }
      else {
         print to_json(\%values, {pretty => $pretty, canonical => $pretty});
      }

      if ($attachments) {
         if ($issue->{key} =~ /^(.*?)-(\d{2})(.*?)/ || $issue->{key} =~ /^(.*?)-(\d)(.*?)/) {
            my $prefix = $1;
            my $num_prefix = $2;
            my $num = $3;

            foreach my $attachment (@{$values{Attachment}}) {

               debug(Dumper($attachment));

               my $filename = convert($attachment->{filename});
               my $filesize = $attachment->{size};
               my $fileid = $attachment->{id};
               my $path = "$attachment_path/$prefix/$num_prefix/$issue->{key}/$fileid";
               my $file = "$path/$filename";

               next if (-e $file && (-s $file == $filesize));
               make_path($path);
               unlink($file);

               msg("Downloading attachment: $issue->{key}/$fileid/$filename\n");
               my $content = $attachment->{content};
               my $cmd = "curl -s -D- -n -X GET -H \"X-Atlassian-Token: nocheck\" -g -o \"$file\" $content";
               debug("$cmd\n");
               my $error = `$cmd`;
               if ($?) {
                  msg("$cmd\n$error\n");
                  unlink($file);
               }

               unless (-e $file) {
                  msg("Download failed> $cmd\n");
               }
            }
         }
      }

      last if ($max && $count >= $max);
   }
   msg("   Start:        ", scalar(localtime($starttime)), "\n");
   msg("   End:          ", scalar(localtime()), "\n");
   msg("   Duration:     ", time() - $starttime, "\n");
   msg("   Count:        $count\n");
   msg("   Seconds Each: ", sprintf("%0.3f", (time() - $starttime)/$count), "\n");
}
print ']', $pretty ? "\n" : '';

if ($ids_file) {
   if (open(FILE,">$ids_file")) {
      print FILE map {"$_\n"} @ids;
      close(FILE);
      msg("Created file: $ids_file\n");
   }
   else {
      msg("Error: Could not open '$ids_file' for writing.\n");
   }
}


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
   my ($query, $api) = @_;
   $api ||= '/rest/api/2';
   my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
   my $client = REST::Client->new();
   $client->setHost("http://$server");
   debug(">$api/$query\n");
   $client->GET("$api/$query", $headers);
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

