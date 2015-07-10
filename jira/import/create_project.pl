#!/usr/bin/perl
# usage:
# perl create_project.pl --source ctrl=ctrl.json --project Controller --key CTRL
# perl create_project.pl --source rtpjira=wlan.json --project WLAN --key WLAN
# perl create_project.pl --source engjira=avb_engjira.json --project AVB --key AVB

use strict;
use Getopt::Long;
use Data::Dumper;
use Config::IniFiles;
use JSON;
use FindBin qw($Bin $Script);
#use lib "$Bin/lib";
use Date::Manip;
use URI::Escape;

$ENV{"TZ"} = "EST5EDT";

$Data::Dumper::Sortkeys = 1;

my $debug = 0;
my $max = 0;
my $encode = 0;
my @sources = ();
my $project = '';
my $key = '';
my $ldap_users = '/tools/oss/packages/share/BRCM/etc/BRCMstaff_All.txt';
my $attachment_path = "/projects/ccxsw_jira/production/jirahome/import/attachments";

my $start_id = '';

my $pretty = 0;
my $nfeed_file = '';
my $users_file = '';
my $linked_file = '';

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

sub convert_username($) {
   my ($username) = @_;

   if ($username =~ /^oem/) {
      return 'oem';
   }
   elsif ($username =~ /^ql(.*?)$/) {
      return $1;;
   }
   return $username;
}

GetOptions('debug'     => \$debug,
           'max=n'     => \$max,
           'enccode'   => \$encode,
           'source=s'  => \@sources,
           'project=s' => \$project,
           'key=s'     => \$key,
           'pretty'    => \$pretty,
           'nfeed=s'   => \$nfeed_file,
           'users=s'   => \$users_file,
           'linked=s'  => \$linked_file,
           'start=s'   => \$start_id,
           );

my $usage = "Usage: migrate_issues.pl --source \"<type>=file name\" [--debug] [--max <n>] .";

unless (@sources) {
   msg("$usage\n\tAt least one source must be specified.\n");
   exit 1;
}

my %user_db;
my %user_email_db;

if (-f $ldap_users) {
   msg("Loading LDAP user file...\n");
   my @userfile = `cat $ldap_users`;
   chomp(@userfile);

   my $headers = shift(@userfile);
   my @headers = split('\|', $headers);

   @headers = map {$_ =~ s/\"//g; $_} @headers;

   my $count=0;
   foreach my $line (@userfile) {
      my %user = ();
      my @values = split('\|', $line);
   #   print STDERR "$line" if ($debug);
      foreach my $i (0..$#headers) {
         my $value = $values[$i];

         if ($value =~ /^\"(.*?)\"$/) {
            $value = $1;
         }
         $user{$headers[$i]} = $value;
      }

      my $username = $user{Acct_Name_Unix} || $user{Acct_Name_NT};
      if ($username =~ /(^.*?)\-r$/) {
         $username = $1;
      }
      $user_db{$username} = \%user;

      my $email = $user{Email_Addr} || "$user{Acct_Name_NT}\@broadcom.com";
      $user_email_db{$email} = \%user;
   }
}

my %field_def;
my $fields_file = "$Bin/field_defs.ini";
if (-e $fields_file) {
   tie %field_def, 'Config::IniFiles', ( -file => $fields_file );
   if (@Config::IniFiles::errors) {
      msg(@Config::IniFiles::errors, "\n");
      exit 1;
   }
}
else {
   print "Could not find field definition file: field_defs.ini\n";
   exit;
}

my %new_issues;
my @issues;
my @links;
my %users;
my %nfeed_values;
my $count = 0;

my $project_map_file = "$Bin/project_map_".lc($key).".ini";
my %project_map;
if (-e $project_map_file) {
   msg("Loading project map $project_map_file...\n");
   tie %project_map, 'Config::IniFiles', ( -file => $project_map_file );
   if (@Config::IniFiles::errors) {
      msg(@Config::IniFiles::errors, "\n");
      exit 1;
   }
}

my $source_users;
my %source_user_db;

if ($users_file) {
   msg("Loading source user file: $users_file.\n");
   my $source_text = `cat $users_file`;
   unless ($source_text) {
      msg("Source users file could not be loaded.\n");
      exit 1;
   }
   msg("Decoding source users file...\n");
   my $source_users = $encode ? decode_json($source_text) : from_json($source_text);

   foreach my $user (@{$source_users}) {
      next unless (defined($user->{login_name}));
      $source_user_db{$user->{login_name}} = $user;
   }
}

my %linked_issues;
if ($linked_file) {
   msg("Loading Linked Issue file: $linked_file.\n");
   my $source_text = `cat $linked_file`;
   unless ($source_text) {
      msg("Linked Issue file could not be loaded.\n");
      exit 1;
   }
   msg("Decoding linked Issue file...\n");
   my $source_issues = $encode ? decode_json($source_text) : from_json($source_text);
   msg("Generating linked Issue list...\n");
   foreach my $issue (@{$source_issues}) {
      if (defined($issue->{key})) {
         $linked_issues{$issue->{key}} = $issue;
      }
   }
}

foreach my $source (@sources) {
   my ($type, $file) = split('=', $source, 2);

   msg("Source: $file ($type)\n");

   my $product;

   if ($type =~ /^(.*?):(.*?)$/) {
      $type = $1;
      $product = $2;
   }

   $type = lc($type);

   my $product_map_file = "$Bin/product_map_${product}.ini";
   my %product_map;
   if (-e $product_map_file) {
      msg("Loading product map $product_map_file...\n");
      tie %product_map, 'Config::IniFiles', ( -file => $product_map_file );
      if (@Config::IniFiles::errors) {
         msg(@Config::IniFiles::errors, "\n");
         exit 1;
      }
   }

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

   my $source_map_file = "$Bin/source_map_${type}.ini";
   msg("Loading source map $source_map_file...\n");
   my %source_map;
   if (-e $source_map_file) {
      tie %source_map, 'Config::IniFiles', ( -file => $source_map_file );
      if (@Config::IniFiles::errors) {
         msg(@Config::IniFiles::errors, "\n");
         exit 1;
      }
   }
   else {
      msg("$Bin${type}_map.ini not found...\n");
      exit;
   }

   msg("Processing ", scalar(@$source_issues), " issues...\n");

   my %issues = map {($_->{id} || $_->{key}) => $_} @$source_issues;

   my @errors;
   foreach my $src_issue (@$source_issues) {
      my %dst_issue;

      my $issue_id = ($type eq 'ctrl') ? $src_issue->{id} : $src_issue->{key};

      # skip over Release issue types
      next if ($src_issue->{'Issue Type'} && $src_issue->{'Issue Type'} eq 'Release');

      if ($start_id) {
         if ($issue_id eq $start_id) {
            $start_id = '';
         }
         else {
            next;
         }
      }

      $count++;
      debug("$issue_id\n");

      # pre-populate fields before mapping
      if ($type eq 'ctrl') {
         # Chip

         $src_issue->{'Chip'} = $src_issue->{'HUT'};

         # don't include HUT_Revision if a form of N/A
#         unless (lc($src_issue->{'HUT_Revision'}) eq 'na' ||
#                 lc($src_issue->{'HUT_Revision'}) eq 'n/a' ||
#                 lc($src_issue->{'HUT_Revision'}) eq 'n.a') {
            $src_issue->{'Chip'} .= '_' . $src_issue->{'HUT_Revision'};
#         }
      }

      # process field value mapping
      foreach my $dst_field (sort(keys(%{$field_def{Fields}}))) {
         debug("$issue_id.$dst_field\n");

         if (defined($source_map{Issues}{"$issue_id.$dst_field"})) {
            $dst_issue{$dst_field} = $source_map{Issues}{"$issue_id.$dst_field"};
         }
         else {
            # determine field mapping
            my $src_fields = $source_map{Fields}{"$dst_field.$product"} || $source_map{Fields}{$dst_field};
            if (defined($src_fields)) {
               if ($src_fields) {
                  # determine field value
                  my $src_field;
                  my $src_values;
                  my $skip_mapping;

                  foreach my $field (split(',', $src_fields)) {
                     $src_field = $field;

                     if ($src_field =~ /^'(.*?)'$/) {
                        $src_values = $1;
                        debug("$issue_id.$dst_field = '$dst_issue{$dst_field}'\n");
                        $skip_mapping = 1;
                     }
                     else {
                        $src_values = $src_issue->{$src_field};
                     }

                     last if (defined($src_values));
                  }

                  debug("$issue_id.$dst_field < $src_field ($src_fields)\n");

                  if ($skip_mapping) {
                     $dst_issue{$dst_field} = $src_values;
                     next;
                  }

                  my @dst_values;
                  if (defined($src_values)) {
                     foreach my $src_value (ref($src_values) eq 'ARRAY' ? @{$src_values} : ($src_values)) {
                        # spaces before endlines
                        $src_value =~ s/\s*\n/\\n/gs;

                        # spaces at beginning or end
                        $src_value =~ s/^\s+//gs;
                        $src_value =~ s/\s+$//gs;

                        # remove non ASCII characters
                        $src_value =~ s/[^!-~\s]//g;

                        # combine multiple spaces into one
                        $src_value =~ s/\s+/ /gs;

                        # = sign
                        $src_value =~ s/=/_/gs;

                        debug("$issue_id.$src_field = $src_value\n");
                        my $dst_value = undef;

                        my $product_fieldmap = $product_map{MappedFields}{$dst_field};
                        if (defined($product_fieldmap)) {
                           $product_fieldmap = $dst_field if ($product_fieldmap eq '');
                           debug("$issue_id.$src_field product fieldmap = $product_fieldmap\n");

                           # find product mapping
                           $dst_value = $product_map{Values}{"$product_fieldmap.$src_value"} if (!defined($dst_value));
                           debug("product: $product_fieldmap.$src_value = $dst_value\n") if (defined($dst_value));

                           $dst_value = $product_map{Values}{"*.$src_value"} if (!defined($dst_value));
                           debug("product: *.$src_value = $dst_value\n") if (defined($dst_value));

                           # find pass-through mappings
                           $dst_value = $product_map{Values}{"$product_fieldmap.*"} if (!defined($dst_value));
                           debug("product: $product_fieldmap.* = $dst_value\n") if (defined($dst_value));
                        }

                        my $project_fieldmap = $project_map{MappedFields}{$dst_field};
                        if (defined($project_fieldmap)) {
                           $project_fieldmap = $dst_field if ($project_fieldmap eq '');
                           debug("$issue_id.$src_field project fieldmap = $project_fieldmap\n");

                           # find project mapping
                           $dst_value = $project_map{Values}{"$project_fieldmap.$src_value"} if (!defined($dst_value));
                           debug("project: $project_fieldmap.$src_value = $dst_value\n") if (defined($dst_value));

                           $dst_value = $project_map{Values}{"*.$src_value"} if (!defined($dst_value));
                           debug("project: *.$src_value = $dst_value\n") if (defined($dst_value));

                           # find pass-through mappings
                           $dst_value = $project_map{Values}{"$project_fieldmap.*"} if (!defined($dst_value));
                           debug("project: $project_fieldmap.* = $dst_value\n") if (defined($dst_value));
                        }

                        my $source_fieldmap = $source_map{MappedFields}{$dst_field};
                        if (defined($source_fieldmap) && !defined($dst_value)) {
                           $source_fieldmap = $dst_field if ($source_fieldmap eq '');
                           debug("$issue_id.$src_field source fieldmap = $source_fieldmap\n");

                           # find source mapping
                           $dst_value = $source_map{Values}{"$source_fieldmap.$src_value"} if (!defined($dst_value));
                           debug("source: $source_fieldmap.$src_value = $dst_value\n") if (defined($dst_value));

                           $dst_value = $source_map{Values}{"*.$src_value"} if (!defined($dst_value));
                           debug("project: *.$src_value = $dst_value\n") if (defined($dst_value));

                           # find pass-through mappings
                           $dst_value = $source_map{Values}{"$source_fieldmap.*"} if (!defined($dst_value));
                           debug("project: $source_fieldmap.* = $dst_value\n") if (defined($dst_value));
                        }
                        if (defined($dst_value)) {
                           $dst_value = $src_value if ($dst_value eq '*');
                        }
                        else {
                           if ($product_fieldmap || $project_fieldmap || $source_fieldmap) {
                              # return an error since this field was mapped, but this value was missed
                              push @errors, "$issue_id: Unmapped $type field value: $dst_field($src_field).'$src_value'\n";
                           }
                           else {
                              $dst_value = $src_value;
                           }
                        }
                        push @dst_values, $dst_value if ($dst_value);
                     }

                     if (@dst_values) {
                        my $dst_value = (ref($src_values) eq '') ? $dst_values[0] : \@dst_values;
                        $dst_issue{$dst_field} = $dst_value;
                     }
                  }
                  else {
                     push @errors, "$issue_id: Unpopulated $type field: $src_field\n";
                     $dst_issue{$dst_field} = $src_values;
                  }
               }
               else {
                  $dst_issue{$dst_field} = '';
               }
            }
            else {
               push @errors, "$issue_id: Unmapped $type field: $dst_field\n";
            }
         }

         if (defined($dst_issue{$dst_field})) {
            $dst_issue{$dst_field} =~ s/\s+?$//; # remove trailing spaces
         }
      }

      # normalize array values
      foreach my $field (sort(keys(%{$field_def{ArrayFields}}))) {
         if (defined($src_issue->{$field})) {
            if ($field_def{ArrayFields}{$field}) {
               # make field an array
               if (ref($dst_issue{$field}) ne 'ARRAY') {
                  $src_issue->{$field} = [$src_issue->{$field}];
               }
            }
            else {
               # make field not an array
               if (ref($src_issue->{$field}) eq 'ARRAY') {

                  # select the first entry that isn't NOT_IMPORTED
                  foreach my $val (@{$src_issue->{$field}}) {
                     next if ($val eq 'NOT_IMPORTED');
                     $src_issue->{$field} = $val;
                     last;
                  }

                  # if no value selected, then set to the first value or blank
                  $src_issue->{$field} ||= $src_issue->{$field}->[0] || '';
               }
            }
         }
      }

      # normalize users in user fields
      foreach my $user_field (qw(Assignee Reporter Verifier Resolver)) {
         if ($dst_issue{$user_field}) {
            $dst_issue{$user_field} = convert_username($dst_issue{$user_field});
         }
      }

###################################################################################################
      # special mapping cases
      if ($type eq 'rtpjira') {

         # Comments
         $dst_issue{'Comments'} = [];
         my $author = '';
         my $created = '';
         my @body = ();

         foreach my $line (split(/\n/, $src_issue->{'Notes Log'})) {
            $line = convert($line);

            if ($line =~ /===== State: .* by:(.*?) at (.*?) =====/) {
               if ($author) {
                  $users{$author} = 1;

                  push @{$dst_issue{'Comments'}}, {body => join("\n", @body),
                                                   author => $author,
                                                   created => $created};
               }
               $author = $1;
               my $date = ParseDate($2);
               my $tz = UnixDate($date, "%Z");
               if ($tz =~ /DT/) {
                  $date = DateCalc($date, '1 hour ago');
               }

               $created = UnixDate($date, "%Y-%m-%dT%H:%M:%S.000%z");

               @body = ();
            }
            else {
               push @body, $line unless (scalar(@body) == 0 && $line =~ /^\s*$/);
            }
         }

         if ($author && scalar(@body)) {
            $author = convert_username($author);

            $users{$author} = 1;

            push @{$dst_issue{'Comments'}}, {body => join("\n", @body),
                                             author => $author,
                                             created => $created};
         }

         # Developer Fix Availabilty Date
#         if ($src_issue->{'Detailed History'} && $src_issue->{'Detailed History'} =~ /) {
#         }

         # Documents
         my %platform_found_on = ('Admin Guide'=>1,
                                  'CLI Reference Manual'=>1,
                                  'Functional Specification'=>1,
                                  'Getting Started Guide'=>1,
                                  'High Level Design Specification'=>1,
                                  'Integration Checklist'=>1,
                                  'Linux Release Notes'=>1,
                                  'Package Release Notes'=>1,
                                  'Product Specification'=>1,
                                  'Quick Start Guide'=>1,
                                  'Reference'=>1,
                                  'Scaling Parameters and Values'=>1,
                                  'SNMP Reference Manual'=>1,
                                  'Software Brief'=>1,
                                  'Strata Release Notes'=>1,
                                  'UI Specification'=>1,
                                  );

         if (defined($src_issue->{'Platform Found On'}) && defined($platform_found_on{$src_issue->{'Platform Found On'}})) {
            $dst_issue{'Documents'} = $src_issue->{'Platform Found On'};
         }

         # Pending Reason
         if (defined($src_issue->{'Unreproducible'}) && $src_issue->{'Unreproducible'} eq 'TRUE') {
            $dst_issue{'Pending Reason'} = 'Cannot Reproduce';
         }
         # Phase Found
         if ($file =~ /14158/ && $dst_issue{'Phase Found'} && $dst_issue{'Phase Found'} eq 'Acceptance Test') {
            $dst_issue{'Phase Found'} = 'Sustaining';
         }

         # Release Note Type
         if (defined($src_issue->{'Permanent README'}) && $src_issue->{'Permanent README'} eq 'TRUE') {
            $dst_issue{'Release Note Type'} = 'PERMANENT';
         }
         if (defined($src_issue->{'Temp Readme'}) && $src_issue->{'Temp Readme'} eq 'TRUE') {
            $dst_issue{'Release Note Type'} = 'TEMPORARY';
         }

         # Resolution Description
         $dst_issue{'Resolution Description'} .= "\n\n***********  START OF SELECTED FIELD VALUES FROM LEGACY ISSUE **********\n\n";

         my @values = ();
         foreach my $src_field ('CLI Affected', 'CLI Effect Description', 'Platforms Affected', 'Unreproducible') {
            my $src_value = $src_issue->{$src_field} || '';

            push @values, <<EOF;
FIELD NAME:  $src_field

FIELD VALUE:

$src_value
EOF
         }
         $dst_issue{'Resolution Description'} .= join("\n<----------------------------------------------------------------------------->\n\n", @values);

         #Severity
         if (defined($src_issue->{'Severity'}) && $src_issue->{'Severity'} eq 'Suggestion') {
            $dst_issue{'Issue Type'} = 'Improvement';
            $dst_issue{'Priority'} = '3-Low';
         }
      }
###################################################################################################
      elsif ($type eq 'engjira' || $type eq 'ingjira' || $type eq 'iprocsw' || $type eq 'pos') {
         my %legacy_values = ('Customers' => $src_issue->{Customers} || '');

         # Comments
         $dst_issue{'Comments'} = [];
         foreach my $comment (@{$src_issue->{'Comment'}}) {
            $users{$comment->{author}->{name}} = 1;
            my $body = $comment->{body};
            $body = convert($body);

            if (length($body) > 1000 ) {
               $body = substr($body, 0, 1000)."...\n [COMMENT TRUNCATED, SEE ORIGINAL ISSUE]";
            }

            push @{$dst_issue{'Comments'}}, {body => $body,
                                             author => $comment->{author}->{name},
                                             created => $comment->{created},
                                             };
         }

         # Chip
         if ($dst_issue{'Chip'} && ref($dst_issue{'Chip'}) eq 'ARRAY') {
            my @chips = grep {$_ ne 'NOT_IMPORTED'} @{$dst_issue{'Chip'}};
            my ($chip, @rest) = @chips;

            $chip ||= 'NOT_IMPORTED';

            $dst_issue{'Chip'} = $chip;
            if (@rest) {
               $legacy_values{'Chip'} = join('\n', @rest);
            }
         }

         # Release Found
         if (ref($dst_issue{'Release Found'}) eq 'ARRAY') {
            $dst_issue{'Release Found'} = $dst_issue{'Release Found'}->[0];
         }

         my $comment = "\n\n***********  START OF SELECTED FIELD VALUES FROM LEGACY ISSUE **********\n\n";

         my @values = ();
         foreach my $src_field (sort(keys(%legacy_values))) {
            my $src_value = $legacy_values{$src_field} || '';

            push @values, <<EOF;
FIELD NAME:  $src_field

FIELD VALUE:

$src_value
EOF
         }
         $comment .= join("\n<----------------------------------------------------------------------------->\n\n", @values);
         $dst_issue{'Issue Description'} .= $comment;
      }
###################################################################################################
      elsif ($type eq 'ctrl') {

         # Normalize date values
         foreach my $field ('Created', 'Resolved') {
            if ($dst_issue{$field}) {
               if ($dst_issue{$field} =~ /^(.*?) (.*?)$/) {
                  $dst_issue{$field} = "$1T$2.000-0500";
               }
            }
         }


         # Comments
         my @comments;

         foreach my $src_field ('Broadcom_Only_Note','VerifyNote','DoesNotVerifyNote','comments','WorkAroundNote') {
            my $src_value = $src_issue->{$src_field} || '';
            $src_value = convert($src_value);

            next unless ($src_value);

            push @comments, {body => "$src_field\n\n$src_value",
                             author => $dst_issue{Reporter},
                             created => $dst_issue{Created},
                            };
            $users{$dst_issue{Reporter}} = 1;
         }

         $dst_issue{'Comments'} = \@comments;

         # Gating Item
         if ($src_issue->{'isBlocking'} eq 'Yes' || $src_issue->{'issue_classification'} eq 'Certification') {
            $dst_issue{'Gating Item'} = 'TRUE';
         }

         # Issue Origin
         if ($src_issue->{'Entry_Type'} eq 'Task') {
            $dst_issue{'Issue Origin'} = 'Development';
         }
         elsif ($src_issue->{'Entry_Type'} eq 'Documentation Change') {
            $dst_issue{'Issue Origin'} = 'Development';
            $dst_issue{'Component'} = 'Documentation';
         }

         if ($dst_issue{'Issue Origin'} ne 'Third Party') {
            if ($src_issue->{'CustomerID'} || $src_issue->{'OEMSubmitterName'}) {
               $dst_issue{'Issue Origin'} = 'Customer';
            }
            else {
               $dst_issue{'Issue Origin'} = 'QA';
            }
         }

         # OS, service_pack
#         if (ref($dst_issue{'OS'}) eq 'ARRAY') {
#            $dst_issue{'OS'} = $dst_issue{'OS'}->[0];
#         }
#         if ($dst_issue{'OS'} =~ /^(.*?)\\n/) {
#            $dst_issue{'OS'} = $1;
#         }

         my $comment = "\n\n***********  START OF SELECTED FIELD VALUES FROM LEGACY ISSUE **********\n\n";

         my @values = ();
         foreach my $src_field ('OS', 
                                'Service_Pack', 
                                'PhyInfo',
                                'SystemID_SerialNo',
                                'RAM_Size',
                                'NIC_Flash_Type',
                                'LOM_NIC',
                                'ASF_IPMI_UMP_Version',
                                'Software_Version',
                                ) {

            my $src_value = $src_issue->{$src_field} || '';

            push @values, <<EOF;
FIELD NAME:  $src_field

FIELD VALUE:

$src_value
EOF
         }
         $comment .= join("\n<----------------------------------------------------------------------------->\n\n", @values);
         $dst_issue{'Issue Description'} .= $comment;

         # Resolution Description
         $dst_issue{'Resolution Description'} .= "\n\n***********  START OF SELECTED FIELD VALUES FROM LEGACY ISSUE **********\n\n";

         my @values = ();
         foreach my $src_field ('Resolution', 'ResolveNote', 'Root_Caused_Note', 'Fixed_In_SW_Version', 'Fixed_In_HW_Version', 'Verified_In_SW_Version', 'Verified_In_HW_Version') {
            my $src_value = $src_issue->{$src_field} || '';

            push @values, <<EOF;
FIELD NAME:  $src_field

FIELD VALUE:

$src_value
EOF
         }
         $dst_issue{'Resolution Description'} .= join("\n<----------------------------------------------------------------------------->\n\n", @values);

         # Status
         if ($src_issue->{'active_deferred_status'} && $src_issue->{'active_deferred_status'} eq 'Deferred') {
            $dst_issue{'Status'} = 'Deferred';

            if ($src_issue->{'deferredreason'}) {
               $dst_issue{'Pending Next Action'} = $dst_issue{'Pending Next Action'} ? "$dst_issue{'Pending Next Action'}\n$src_issue->{'deferredreason'}" : $src_issue->{'deferredreason'};
            }
         }
      }
      elsif ($type eq 'tools') {
         # Comments
         $dst_issue{'Comments'} = [];
         foreach my $comment (@{$src_issue->{'Comment'}}) {
            $users{$comment->{author}->{name}} = 1;
            my $body = $comment->{body};
            $body = convert($body);

            if (length($body) > 1000 ) {
               $body = substr($body, 0, 1000)."...\n [COMMENT TRUNCATED, SEE ORIGINAL ISSUE]";
            }

            push @{$dst_issue{'Comments'}}, {body => $body,
                                             author => $comment->{author}->{name},
                                             created => $comment->{created},
                                             };
         }
      }


      $dst_issue{'Severity'} ||= '4-Minor';
      $dst_issue{'Priority'} ||= '3-Low';
      $dst_issue{'Customer'} ||= 'Broadcom';
      $dst_issue{'Resolution'} = 'Fixed' if ($dst_issue{'Status'} eq 'Closed');
      $dst_issue{'Resolution'} = 'Won\'t Fix' if ($dst_issue{'Status'} eq 'Canceled');

      if (defined($dst_issue{'Legacy Issue #'})) {
         $dst_issue{'Legacy Issue URL'} = $dst_issue{'Legacy Issue URL'}.$dst_issue{'Legacy Issue #'};
      }

      if ($dst_issue{'Developer Fix Availability Date'}) {
         my $date = ParseDate($dst_issue{'Developer Fix Availability Date'});
         if ($date) {
            my $datestr = UnixDate($date, "%d/%b/%y %i:%M %p");
            $datestr =~ s/  / /g;
            $dst_issue{'Developer Fix Availability Date'} = $datestr;
         }
      }

      # record users from user fields
      foreach my $user_field (qw(Assignee Reporter Verifier Resolver)) {
         if ($dst_issue{$user_field}) {
            my $username = convert_username($dst_issue{$user_field});

            # if user is a local user, find out which LDAP user it actually is
            if (defined($source_user_db{$username}) && $username ne 'oem') {
               my $email = $source_user_db{$username}->{email};
               debug("Found user '$username' in source db: $email\n");
               if (defined($user_email_db{$email})) {
                  my $new_user = $user_email_db{$email};
                  my $new_username = $new_user->{Acct_Name_NT};
                  $new_username = $new_user->{Acct_Name_Unix} if ($new_username eq '' || $new_username eq ' ' || $new_username eq 'n/a');
                  if ($dst_issue{$user_field} ne $new_username) {
                     debug("\tMapping Source User: ($dst_issue{$user_field}) -> $new_username\n");
#                     msg(Dumper($new_user));
                     $dst_issue{$user_field} = $new_username;
                  }
               }
               else {
                  debug("No match for email in LDAP db\n");
               }
               if (defined($user_db{$username})) {
                  my $email = $user_db{$username}->{Email_Addr};
                  debug("Found user '$username' in LDAP db: $email\n");
               }
            }

            $users{$dst_issue{$user_field}} = 1;
         }
      }

      # process issue links
      if (defined($src_issue->{'Linked Issues'})) {
         # process jira links
         foreach my $link (@{$src_issue->{'Linked Issues'}}) {
            my %link;

            if (defined($link->{inwardIssue})) {
               $link{sourceId} = $link->{inwardIssue}->{key};
               $link{destinationId} = $src_issue->{key};
            }
            elsif (defined($link->{outwardIssue})) {
               $link{destinationId} = $link->{outwardIssue}->{key};
               $link{sourceId} = $src_issue->{key};
            }

            # don't link to issues not in this source
            unless (defined($issues{$link{destinationId}}) && defined($issues{$link{sourceId}})) {
               debug("Ignoring link between $link{destinationId} and $link{sourceId}\n");
               next;
            }

            # check to see if a linked issue with an IMS Case ID field
            if (defined($linked_issues{$link{sourceId}}) && 
                $linked_issues{$link{sourceId}}->{'Issue Type'} eq 'TSR' && 
                defined($linked_issues{$link{sourceId}}->{'IMS Case ID'}) && 
                $linked_issues{$link{sourceId}}->{'IMS Case ID'} ne '') {
               $dst_issue{'IMS Case ID'} = $linked_issues{$link{sourceId}}->{'IMS Case ID'};
               msg("$issue_id -> $link{sourceId} = $dst_issue{'IMS Case ID'}\n");
            }
            if (defined($linked_issues{$link{sourceId}}) && 
                $linked_issues{$link{destinationId}}->{'Issue Type'} eq 'TSR' && 
                defined($linked_issues{$link{sourceId}}->{'IMS Case ID'}) && 
                $linked_issues{$link{destinationId}}->{'IMS Case ID'} ne '') {
               $dst_issue{'IMS Case ID'} = $linked_issues{$link{destinationId}}->{'IMS Case ID'};
               msg("$issue_id -> $link{destinationId} = $dst_issue{'IMS Case ID'}\n");
            }

            $link{name} = 'Relates';
            debug("$link{sourceId} -> $link{destinationId}\n");
            push @links, \%link;
         }
      }
      elsif (defined($src_issue->{'OtherRelatedDefects'})) {
         foreach my $destination (split("\n", $src_issue->{'OtherRelatedDefects'})) {
            my %link = (sourceId => $src_issue->{id},
                        destinationId => $destination,
                        name => 'Relates');

            debug("$link{sourceId} -> $link{destinationId}\n");
            push @links, \%link;
         }
      }

      my %new_issue = (customFieldValues => [],
                       externalId => $dst_issue{'Legacy Issue #'} || ''
                       );

      my %processed_fields = ();

      foreach my $field (sort(keys(%{$field_def{Fields}}))) {
         my $field_value = $dst_issue{$field};
         next unless ($field_value);

         $field_value = convert($field_value);

         my $builtin_field = $field_def{Fields}{$field};

         if ($builtin_field) {
            $new_issue{$builtin_field} = $field_value;
         }
         else {
            my $field_type = $field_def{FieldTypes}{$field};
            unless ($field_type) {
               print STDERR "Unknown field type for field: $field\n";
               exit 1;
            }

            if ($field_type eq 'com.valiantys.jira.plugins.SQLFeed:com.valiantys.jira.plugins.sqlfeed.customfield.type') {
               # dereference if array
               foreach my $nfeed_val (ref($field_value) eq 'ARRAY' ? @{$field_value} : ($field_value)) {
                  $nfeed_val =~ s/\"/\"\"/g;
                  next if ($nfeed_val eq 'NOT_IMPORTED' || $nfeed_val eq 'BLANK' || $nfeed_val eq '');

                  my $nfeed_table = $field_def{nFeedFields}{$field};
                  my $nfeed_value = '';
                  my $nfeed_blank = '';

                  if ($nfeed_table eq 'Product' ||
                      $nfeed_table eq 'OS' ||
                      $nfeed_table eq 'Document'
                      ) {
                     $nfeed_value = "(Project, Value) VALUES (\"$key\", \"$nfeed_val\")";
                     $nfeed_blank = "(Project, Value) VALUES (\"$key\", \"BLANK\")";
                  }
                  elsif ($nfeed_table eq 'Customer' || 
                         $nfeed_table eq 'Package' || 
                         $nfeed_table eq 'Software_Component' || 
                         $nfeed_table eq 'Target_Branch'
                        ) {

                     unless ($dst_issue{Product}) {
                        print STDERR "Unknown index for nFeed value: $issue_id, key = \"$key\", product = \"$dst_issue{Product}\"\n";
                        exit 1;
                     }

                     next if ($dst_issue{Product} eq 'NOT_IMPORTED');
                     next if ($key eq 'CTRL' && $nfeed_table eq 'Customer' && $nfeed_val ne 'Broadcom');

                     
                     $nfeed_value = "(Project, Product, Value) VALUES (\"$key\", \"$dst_issue{Product}\", \"$nfeed_val\")";
                     $nfeed_blank = "(Project, Product, Value) VALUES (\"$key\", \"$dst_issue{Product}\", \"BLANK\")";
                  }
                  elsif ($nfeed_table eq 'Chip' || 
                         $nfeed_table eq 'Hardware_Board_Revision' ||
                         $nfeed_table eq 'Releases'
                        ) {
                     unless ($dst_issue{Product} && $dst_issue{Customer}) {
                        print STDERR "Unknown index for nFeed value: $issue_id, key = \"$key\", product = \"$dst_issue{Product}\", customer = \"$dst_issue{Customer}\"\n";
                        exit 1;
                     }

                     next if ($dst_issue{Product} eq 'NOT_IMPORTED' || $dst_issue{Customer} eq 'NOT_IMPORTED');
                     next if ($key eq 'CTRL' && $dst_issue{Customer} ne 'Broadcom');

                     $nfeed_value = "(Project, Product, Customer, Value) VALUES (\"$key\", \"$dst_issue{Product}\", \"$dst_issue{Customer}\", \"$nfeed_val\")";
                     $nfeed_blank = "(Project, Product, Customer, Value) VALUES (\"$key\", \"$dst_issue{Product}\", \"$dst_issue{Customer}\", \"BLANK\")";
                  }
                  else {
                     print STDERR "Unknown nFeed table: $nfeed_table\n";
                     exit 1;
                  }
                  $nfeed_blank = '' if ($nfeed_table eq 'Customer' || $nfeed_table eq 'Product');

                  unless ($nfeed_value) {
                     print STDERR "Missing nFeed value: $nfeed_table = $nfeed_val\n";
                     exit 1;
                  }
                  $nfeed_value .= "$issue_id.$field" if ($debug);

                  $nfeed_values{$nfeed_table} ||= {};
                  $nfeed_values{$nfeed_table}{$nfeed_value} = 1;
                  $nfeed_values{$nfeed_table}{$nfeed_blank} = 1 if ($nfeed_blank);
               }
            }
            push @{$new_issue{customFieldValues}}, {fieldName => $field,
                                                    fieldType => $field_type,
                                                    value => $field_value};
         }
      }

      # Attachments
      my $path = $issue_id;
      if ($issue_id =~ /^(.*?)-(\d{2})/ || $issue_id =~ /^(.*?)-(\d{1})/ || $issue_id =~ /^(.*?)0+(\d{2})/) {
         $path = "$1/$2/$issue_id";
      }

      my @attachments;
      my %attachments;
      if ($type eq 'ctrl') {
         foreach my $attachment (@{$src_issue->{Attachments}}) {
            my $filename = convert($attachment->{filename});

            # skip duplicate attachments
            next if (defined($attachments{$filename}));
            $attachments{$filename} = 1;

            unless (-e "$attachment_path/$path/$filename") {
               push @errors, "Unknown attachment for $issue_id: $path/$filename\n";
               next;
            }

            my $author = convert_username($dst_issue{Reporter});
            $users{$author} = 1;

            my $url = "file://$path/".uri_escape($filename);
            push @attachments, {name => $filename,
                                attacher => $author,
                                created => $dst_issue{Created},
                                uri => $url,
                                description => convert($attachment->{description}),
                                };
         }
      }
      else {
         foreach my $attachment (@{$src_issue->{Attachment}}) {
            my $filename = convert($attachment->{filename});

            # skip duplicate attachments
            next if (defined($attachments{$filename}));
            $attachments{$filename} = 1;

            my $fileid = $attachment->{id};
            my $author = convert_username($attachment->{author}->{name});
            $users{$author} = 1;

            unless (-e "$attachment_path/$path/$fileid/$filename") {
               push @errors, "Unknown attachment for $issue_id: $path/$fileid/$filename\n";
               next;
            }
            my $url = "file://$path/$fileid/".uri_escape($filename);
            push @attachments, {name => $filename,
                                attacher => $author,
                                created => $attachment->{created},
                                uri => $url,
                                description => convert($attachment->{description}) || '',
                                };
         }
      }
      $new_issue{'attachments'} = \@attachments if (@attachments);

      # record the legacy issue # to prevent importing this defect multiple times
      next if (defined($new_issues{$dst_issue{'Legacy Issue #'}}));
      $new_issues{$dst_issue{'Legacy Issue #'}} = \%new_issue;

      push @issues, \%new_issue;

      debug("Source Issue:\n", Dumper($src_issue));
      debug("Destination Issue:\n", Dumper(\%dst_issue));
#      debug("New Issue:\n", Dumper(\%new_issue));

      last if ($max && $count >= $max);
   }
   # check for mapping errors
   if (scalar(@errors)) {
      msg("Errors during processing:\n", @errors, "\n");
   }

   last if ($max && $count >= $max);
}

msg("Processing complete.\n");
                                      
my %emails;
my @users;
foreach my $user (sort(keys(%users))) {
   my $fullname = $user;
   my $email = "$user\@broadcom.com";

   if (defined($user_db{$user})) {
      $fullname = $user_db{$user}{_Full_Name_};
      $email = $user_db{$user}{Email_Addr};
   }
   if (defined($emails{$email})) {
      $email = "$user\@broadcom.com";
      msg("$user -> $email -> $fullname\n");
   }
   $emails{$email} = 1;
   push @users, {"name"     => $user,
                 "active"   => 'false',
                 "email"    => $email,
                 "fullname" => $fullname,
                 };
}

# Sort issues by Created.
msg("Sorting issues by creation date...\n");
@issues = sort {"$a->{created}.$a->{externalId}" cmp "$b->{created}.$b->{externalId}"} @issues;

my %project = (name => $project,
               key => $key,
               issues => \@issues,
               );

msg("Converting issues to JSON format...\n");
if ($encode) {
   print encode_json({users    => \@users,
                      links    => \@links,
                      projects => [\%project]});
}
else {
   print to_json({users    => \@users,
                  links    => \@links,
                  projects => [\%project]},
                  {pretty => $pretty, canonical => $pretty});
}

if ($nfeed_file) {
   if (open(FILE, ">$nfeed_file")) {
      foreach my $field (sort(keys(%nfeed_values))) {

         print FILE "DELETE FROM $field WHERE Project = \"$key\" AND id$field != 0;\n";
         foreach my $value (sort(keys(%{$nfeed_values{$field}}))) {
            print FILE "INSERT IGNORE INTO $field $value;\n";
         }
         print FILE "\n";
      }
   }
}
