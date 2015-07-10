#!cqperl
use strict;
use CQPerlExt;
use Getopt::Long;
use Data::Dumper;
use File::Path;
use FindBin qw($Bin $Script);
use lib "$Bin/../../perllib";
use JSON;

$Data::Dumper::Sortkeys = 1;

# Usage:
# export_cq.pl --db <db> --type <type> [--id <id> ...] [--id_file <input/output file>]"
#
# Example:
# cqperl export_cq.pl --db LVL7 --repo BROADCOM-RDUB --type Issue --max 1
# cqperl export_cq.pl --db Cont --repo Controller --type Defect --query "Public Queries/CCX-SW JIRA Import/CCX-SW JIRA Import-All NX1" --max 1 >lvl7.json

my $debug = 1;
my $db = '';
my $repo = '';
my $type = '';
my $query = '';
my $username = '';
my $max = 0;
my $start = '';
my $pretty = 1;
my $encode = 0;
my $attachments = 1;
my $attachment_path = 'z:/projects/ccxsw_jira/production/jirahome/import/attachments';

my @ids = ();
my $ids_file = '';
$| = 0;

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

   $text =~ s/\<sup\>//g;
   $text =~ s/\<\/sup\>//g;
   
   return $text;
}

GetOptions('debug'     => \$debug,
           'db=s'      => \$db,
           'repo=s'    => \$repo,
           'type=s'    => \$type,
           'query=s'   => \$query,
           'id=s'      => \@ids,
           'file=s'    => \$ids_file,
           'start=s'   => \$start,
           'max=n'     => \$max,
           'pretty'    => \$pretty,
           'encode!'   => \$encode,
           'user=s'    => \$username,
           'attachments!' => \$attachments,
           );

my $usage = "Usage: export_cq.pl --db <db> --type <type> [--id <id> ...] [--id_file <input/output file>]";

unless ($db && $repo && $type) {
   msg("$usage\n\tdb, repo, and type must be specified.\n");
   exit 1;
}

my $session  = CQSession::Build();

msg("Connecting to CQ database '$repo.$db'\n");
my ( $user, $password ) = &login($username);
eval { $session->UserLogon( $user, $password, $db, $repo ); };

if ($@) {
    msg("Can't log on to CQ: $@");
    exit;
}

# Create workspace
my $workspace = $session->GetWorkSpace();


unless (scalar (@ids)) {
   if (-e $ids_file) {
      &msg("Loading issues from '$ids_file'\n");
      my %id_hash;
      if (open(FILE, "<$ids_file")) {
         foreach my $line (<FILE>) {
            next if $line =~ /^#/;
            chomp($line);

            $id_hash{$line} = 1;
         }
      }
      @ids = sort(keys(%id_hash));
      unless (scalar(@ids)) {
         &msg("No ids found in file: $ids_file\n");
         exit 1;
      }
      &msg("Loaded ", scalar(@ids), " $type records (last: $ids[-1]).\n");
   }
   else {
      # Load all Records
      my $querydef = $query ? $workspace->GetQueryDef($query) : $session->BuildQuery($type);
      $querydef->BuildField('dbid');

      if ($type eq 'users') {
         $querydef->BuildField('login_name');
      }
      else {
         $querydef->BuildField('id');
      }

      my $results = $session->BuildResultSet($querydef);
      $results->Execute();

      my %id_hash = ();
      my $status = $results->MoveNext();
      while ($status == $CQPerlExt::CQ_SUCCESS) {
         my $dbid = $results->GetColumnValue(1);
         my $id = $results->GetColumnValue(2);

         $id_hash{$id} = 1;
         $status = $results->MoveNext();
      }

      @ids = sort(keys(%id_hash));
      &msg("Loaded ", scalar(@ids), " $type records (last: $ids[-1]).\n");

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
   }
}

my $starttime = time();
my $count = 0;
my %json;
print '[', $pretty ? "\n" : '';
foreach my $id (@ids) {

   if ($start) {
      if ($start eq $id) {
         $start = '';
      }
      else {
         next;
      }
   }
   debug("$id\n");

   # Load all fields
   my $record = $session->GetEntity($type, $id);
   my %fields;

   foreach my $field (@{$record->GetFieldNames()}) {
      $fields{$field} = convert($record->GetFieldValue($field)->GetValue());
   }

   my $attachfields = $record->GetAttachmentFields();
   my $numfields = $attachfields->Count();

   if ($attachments && $id =~ /^([a-z]+)0*(\d{2})/i) {
      my $filepath = "$attachment_path/$1/$2/$id";

      my @attachments = ();
      my %attachments = ();

      for (my $fieldnum = 0; $fieldnum < $numfields ; $fieldnum++) {
         # Get each attachment field
         my $attachfield = $attachfields->Item($fieldnum);
         my $attachfield_name = $attachfield->GetFieldName();

         # Get attachments list
         my $attachments = $attachfield->GetAttachments(); 
         my $numattachments = $attachments->Count();   
         for (my $attachnum = 0 ; $attachnum < $numattachments ; $attachnum++) { 
            my $attachment = $attachments->Item($attachnum); 
            my $filename = convert($attachment->GetFileName()); 
            my $filesize = $attachment->GetFileSize(); 
            my $description = $attachment->GetDescription(); 
            next if ($filename eq 'history.txt');

            # Prefix with ~ if duplicate
            $filename = "~$filename" if (defined($attachments{$filename}));
            $attachments{$filename} = 1;
            push @attachments, {filename => $filename,
                                filesize => $filesize,
                                field => $attachfield_name,
                                description => $description
                                };

            unless (-e "$filepath/$filename" && (-s "$filepath/$filename" == $filesize)) {
               mkpath($filepath);
               msg("Downloading attachment: $filename\n");
               my $status = $attachment->Load("$filepath/$filename"); 
               unless ($status) {
                  msg("Failed to download attachment\n");
               }
            }
         }
         delete($fields{$attachfield_name});
      }
      $fields{Attachments} = \@attachments;
   }

   $count++;
   print ",", $pretty ? "\n" : '' if ($count > 1);
   if ($encode) {
      print encode_json(\%fields);
   }
   else {
      print to_json(\%fields, {pretty => $pretty, canonical => $pretty});
   }

   last if ($max && $count >= $max);
}
print ']', $pretty ? "\n" : '';

msg("Start:        ", scalar(localtime($starttime)), "\n");
msg("End:          ", scalar(localtime()), "\n");
msg("Duration:     ", time() - $starttime, "\n");
msg("Count:        $count\n");
msg("Seconds Each: ", (time() - $starttime)/$count);

sub login {
    use Term::ReadKey;
    my ($user, $password) = @_;

    unless ($user) {
       if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
          foreach my $line (<NETRC>) {
             chomp($line);
             if ($line =~ /^machine clearquest login (.*?) password (.*?)$/) {
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
        print("\n");
    }
    chomp($user);
    chomp($password);

    return ( $user, $password );
}

