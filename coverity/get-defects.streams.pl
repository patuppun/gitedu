#!/usr/bin/perl

=pod

=head1 COPYRIGHT

(c) 2013 Coverity, Inc. All rights reserved worldwide.

=head1 NAME

get-defects.pl


=head1 SYNOPSIS

get-defects.pl [options] --project PROJECT 
get-defects.pl [options] --stream STREAM1 --stream STREAM2 ...


=head1 OPTIONS

=over 12

=item Required:

=item B<--project>

List all defects in all streams belonging to a PROJECT OR

=item B<--stream>

List all defects in STREAM(s)

=item Optional:

=item B<--config>

CONFIG_FILE e.g coverity_pse_config.xml OR

=item B<--host>

Connect server HOST

=item B<--port>

Connect server PORT

=item B<--ssl>

Use SSL if defined

=item B<--username>

Connect server USERNAME with admin access

=item B<--password>

Connect server PASSWORD

=item B<--help>

Print documentation and exit

=back


=head1 DESCRIPTION

List all defects in a given project or stream(s).  Retrieve the defect
id, and triage information.


=head1 CONFIGURATION

This script can optionally use a configuration file (usually
coverity_pse_config.xml) for Connect server information.


=head1 AUTHOR


=cut

##############################################################################
####### Initialization #######################################################

use strict;

use FindBin qw($Bin $Script);

BEGIN {
# Uncomment to bypass SSL certificate verification
#  $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

  unshift(@INC, "$Bin/../perllib");
  unshift(@INC, "$Bin/../perllib/cpan/SOAP-Lite-0.714");
  unshift(@INC, "$Bin/../perllib/cpan/Class-Inspector-1.25");
  unshift(@INC, "$Bin/../perllib/cpan/XML-Simple-2.18");

# Uncomment if the base Perl install does not have XML::SAX
#  push(@INC, "$Bin/lib/cpan/XML-SAX-coverity");
#  push(@INC, "$Bin/lib/cpan/XML-SAX-Base-1.08/lib");
#  push(@INC, "$Bin/lib/cpan/XML-NamespaceSupport-1.11/lib");

# Uncomment if the base Perl install does not have HTTP
#  push(@INC, "$Bin/lib/cpan/URI-1.59");
#  push(@INC, "$Bin/lib/cpan/Net-HTTP-6.02/lib");
#  push(@INC, "$Bin/lib/cpan/libwww-perl-6.03/lib");
#  push(@INC, "$Bin/lib/cpan/HTTP-Message-6.02/lib");
#  push(@INC, "$Bin/lib/cpan/HTTP-Date-6.00/lib");
  $Script =~ s/\.pl//g;
};

# Uncomment if the base Perl install does not have XML::SAX
#$XML::Simple::PREFERRED_PARSER = 'XML::SAX::PurePerl';

use Getopt::Long;
use Data::Dumper;
use Pod::Usage;

#use SOAP::Lite +trace => 'debug';
use SOAP::Lite;

use Coverity::Config;
use Coverity::WSCoverity_v3;
use Coverity::WSCoverity_v7;
use Coverity::WSCoverity_v8;


##############################################################################
####### Global data and configuration ########################################

my @opt_projects;
my $opt_branch;
my @opt_streams;

my $opt_filter;

my $opt_host;
my $opt_port;
my $opt_ssl = 0;
my $opt_username;
my $opt_password;
my $opt_version=7;

my $opt_coverity_config;

my $opt_help = 0;

my $opt_sep = ',';

my $debug = 0;
my $max = 0;
my $only = 0;


##############################################################################
####### Subroutines ##########################################################

sub handle_command_line_options {
  GetOptions(
    # What to operate on
    'project=s' => \@opt_projects,
    'stream=s' => \@opt_streams,
    'filter=s' => \$opt_filter,
    # Standard Coverity Connect options
    'host=s' => \$opt_host,
    'port=s' => \$opt_port,
    'ssl!' => \$opt_ssl,
    'username=s' => \$opt_username,
    'password=s' => \$opt_password,
    'version=n' => \$opt_version,
    # Common script options
    'config=s' => \$opt_coverity_config,
    'help|?' => \$opt_help,
    'debug' => \$debug,
    'max=n' => \$max,
    'only=n' => \$only,
    'sep=s' => \$opt_sep,
  ) or pod2usage(-verbose => 1);
  pod2usage(-verbose => 2) if $opt_help;
  pod2usage(-verbose => 1) if (@opt_projects == 0 && !$opt_branch && @opt_streams == 0);

  # Load configuration and set values from config file if specified
  if ($opt_coverity_config) {
    my $coverityConfig = new Coverity::Config(filename => $opt_coverity_config);

#    $coverityConfig->dump() if ($debug);


    # Command-line options override values in config file.
    $opt_host = $opt_host ? $opt_host : $coverityConfig->get_connect_host();
    $opt_port = $opt_port ? $opt_port : $coverityConfig->get_connect_port();
    $opt_ssl = $opt_ssl ? $opt_ssl : $coverityConfig->get_connect_ssl();
    $opt_username = $opt_username ? $opt_username : $coverityConfig->get_connect_username();
    $opt_password = $opt_password ? $opt_password : $coverityConfig->get_connect_password();
  }

  if (!$opt_host or !$opt_port or !$opt_username or !$opt_password) {
    print "Must specify Coverity Connect server and authentication details on command line or configuration file\n";
    pod2usage(-verbose => 1);
  }
}


##############################################################################
######## Main Script #########################################################

handle_command_line_options();

my $connectUrl = undef;
if ($opt_ssl) {
  $connectUrl = "https://$opt_host:$opt_port";
} else {
  $connectUrl = "http://$opt_host:$opt_port";
}

my $defectProxy = undef;
my $configProxy = undef;
my $coverityWS = undef;

if ($opt_version == 3) {
   $defectProxy = SOAP::Lite->proxy("$connectUrl/ws/v3/defectservice")->uri('http://ws.coverity.com/v3');
   $defectProxy->transport->timeout(200);
   $defectProxy->serializer->register_ns('http://ws.coverity.com/v3', 'ws');

   $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v3/configurationservice")->uri('http://ws.coverity.com/v3');
   $configProxy->transport->timeout(200);
   $configProxy->serializer->register_ns('http://ws.coverity.com/v3', 'ws');

   $coverityWS = new Coverity::WSCoverity_v3(username => $opt_username, password => $opt_password, debug => $debug);
}
elsif ($opt_version == 7) {
   $defectProxy = SOAP::Lite->proxy("$connectUrl/ws/v7/defectservice")->uri('http://ws.coverity.com/v7');
   $defectProxy->transport->timeout(200);
   $defectProxy->serializer->register_ns('http://ws.coverity.com/v7', 'ws');

   $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v7/configurationservice")->uri('http://ws.coverity.com/v7');
   $configProxy->transport->timeout(200);
   $configProxy->serializer->register_ns('http://ws.coverity.com/v7', 'ws');

   $coverityWS = new Coverity::WSCoverity_v7(username => $opt_username, password => $opt_password, debug => $debug);
}
elsif ($opt_version == 8) {
   $defectProxy = SOAP::Lite->proxy("$connectUrl/ws/v8/defectservice")->uri('http://ws.coverity.com/v8');
   $defectProxy->transport->timeout(200);
   $defectProxy->serializer->register_ns('http://ws.coverity.com/v8', 'ws');

   $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v8/configurationservice")->uri('http://ws.coverity.com/v8');
   $configProxy->transport->timeout(200);
   $configProxy->serializer->register_ns('http://ws.coverity.com/v8', 'ws');

   $coverityWS = new Coverity::WSCoverity_v8(username => $opt_username, password => $opt_password, debug => $debug);
}

my @filter = ();
if ($opt_filter) {
  foreach my $filter (split(';', $opt_filter)) {
     my ($key,$vals) = split('=', $filter);
     if ($key =~ /List$/) {
        foreach my $val (split(',',$vals)) {
           push @filter,
              SOAP::Data->name($key =>
                               \SOAP::Data->value(
                                  SOAP::Data->name('name' => SOAP::Data->type('string' => $val))));
        }
     }
     else {
        push @filter, SOAP::Data->name($key => $vals);
     }
  }
}

print Dumper(\@filter) if ($debug);

# fetch checker severities
my @checkers = $coverityWS->get_checker_properties($configProxy);
#  print Dumper(\@checkers) if ($debug);

my %impact;
if (@checkers) {
  foreach my $checker (@checkers) {
     $impact{"$checker->{checkerSubcategoryId}->{checkerName}.$checker->{checkerSubcategoryId}->{subcategory}"} = $checker->{impact};
  }
}
else {
  if (open(FILE, "<$Bin/checker_impact.cfg")) {
     foreach my $line (<FILE>) {
        chomp($line);
        $impact{$1} = $2 if ($line =~ /^(.*?) = (.*?)$/s);
     }
  }
}

print Dumper(\%impact) if ($debug);

my %streams;
if (@opt_projects) {
  my %projects;
  foreach my $opt_project (@opt_projects) {
     # if '*' is specified, load all available projects on the server
     if ($opt_project eq '*') {
        my @project_data = $coverityWS->get_projects($configProxy, {});
        foreach my $project (@project_data) {
           $projects{$project->{id}->{name}} = 1;
        }
     }
     else {
        if ($opt_project =~ /^\-(.*?)$/) {
           $projects{$1} = 0;
        }
        elsif ($opt_project =~ /,/) {
           foreach my $project (split(/,/, $opt_project)) {
              $projects{$project} = 1;
           }
        }
        else {
           $projects{$opt_project} = 1;;
        }
     }
  }

  print Dumper(\%projects) if ($debug);

  # fetch stream information
  my @all_streams =  $coverityWS->get_streams($configProxy, {});

  print Dumper(\@all_streams) if ($debug);

  foreach my $stream (@all_streams) {
     next if ($stream->{outdated} eq 'true');
     next unless ($projects{$stream->{primaryProjectId}->{name}});
 
     $streams{$stream->{id}->{name}} = 1;
  }
}

foreach my $opt_stream (@opt_streams) {
   if ($opt_stream =~ /^\-(.*?)$/) {
      $streams{$1} = 0;
   }
   else {
      $streams{$opt_stream} = 1;;
   }
}


print Dumper(\%streams) if ($debug);

my @streams = grep {$streams{$_}} keys(%streams);

if (@streams) {
  my @defects = $coverityWS->get_merged_defects_for_streams($defectProxy, \@streams, \@filter);

  my %defects;
  foreach my $defect (@defects) {
     print Dumper($defect) if ($debug && $max);

     my %attributes;
     foreach my $attribute (@{$defect->{defectStateAttributeValues}}) {
        my $name = $attribute->{attributeDefinitionId}->{name};
        my $val = $attribute->{attributeValueId};
        $val = $val->{name} if (ref($val) eq 'HASH');
        $attributes{$name} = $val || '';
     }
     $defect->{attributes} = \%attributes;
     $defect->{checkerName} ||= $defect->{checker};
     $defect->{checkerImpact} = $impact{"$defect->{checkerName}.$defect->{checkerSubcategory}"} || 'Low';

     $defects{$defect->{cid}} = $defect;

     print Dumper($defects{$defect->{cid}}) if ($debug && $max);
  }

  print join($opt_sep, qw(cid date checker subchecker impact component file function status severity)), "\n";

  # iterate through all found issues
  my $count = 0;
  foreach my $cid (sort {$a <=> $b} keys(%defects)) {
     next if ($only && $cid != $only);
     my $defect = $defects{$cid};
     print Dumper($defect) if ($debug && $max);

     # pull data that is common to all occurances
     my @row = ($cid, 
                $defect->{firstDetected},
                $defect->{checkerName},
                $defect->{checkerSubcategory},
                $defect->{checkerImpact},
                $defect->{componentName},
                $defect->{filePathname},
                $defect->{functionDisplayName},
                $defect->{attributes}->{DefectStatus},
                $defect->{attributes}->{Severity},
               );

     @row = map {$_ =~ /,/ ? "\"$_\"" : $_} @row if ($opt_sep eq ',');
     print join($opt_sep,@row),"\n";
     $count++;
     last if ($max && $count >= $max);
  }
} 
exit;
