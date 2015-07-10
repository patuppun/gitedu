#!/usr/bin/perl

=pod

=head1 COPYRIGHT

(c) 2013 Coverity, Inc. All rights reserved worldwide.

=head1 NAME

get-snapshots.pl


=head1 SYNOPSIS

get-snapshots.pl [options] --project PROJECT (OR --stream STREAM1 --stream STREAM2 ...)


=head1 OPTIONS

=over 12

=item Required:

=item B<--project>

List all snapshots in all streams belonging to a PROJECT OR

=item B<--stream>

List all snapshots in STREAM(s)

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

List all snapshots in a given project or stream(s).  Retrieve the snapshot
target, version, and description labels.  Also show the stream and date created.


=head1 CONFIGURATION

This script can optionally use a configuration file (usually
coverity_pse_config.xml) for Connect server information.


=head1 AUTHOR

Sumio Kiyooka (skiyooka@coverity.com)


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
use Coverity::WSCoverity;


##############################################################################
####### Global data and configuration ########################################

my $opt_project;
my @opt_streams;

my $opt_host;
my $opt_port;
my $opt_ssl = 0;
my $opt_username;
my $opt_password;

my $opt_coverity_config;

my $opt_help = 0;

my $debug = 0;


##############################################################################
####### Subroutines ##########################################################

sub handle_command_line_options {
  GetOptions(
    # What to operate on
    'project=s' => \$opt_project,
    'stream=s' => \@opt_streams,
    # Standard Coverity Connect options
    'host=s' => \$opt_host,
    'port=s' => \$opt_port,
    'ssl!' => \$opt_ssl,
    'username=s' => \$opt_username,
    'password=s' => \$opt_password,
    # Common script options
    'config=s' => \$opt_coverity_config,
    'help|?' => \$opt_help,
    'debug' => \$debug,
  ) or pod2usage(-verbose => 1);
  pod2usage(-verbose => 2) if $opt_help;
  pod2usage(-verbose => 1) if (!$opt_project && @opt_streams == 0);

  # Load configuration and set values from config file if specified
  if ($opt_coverity_config) {
    my $coverityConfig = new Coverity::Config(filename => $opt_coverity_config);

    $coverityConfig->dump() if ($debug);


    # Command-line options override values in config file.
    $opt_host = $opt_host ? $opt_host : $coverityConfig->get_connect_host();
    $opt_port = $opt_port ? $opt_port : $coverityConfig->get_connect_port();
    $opt_ssl = $opt_ssl ? $opt_ssl : $coverityConfig->get_connect_ssl();
    $opt_username = $opt_username ? $opt_username : $coverityConfig->get_connect_username();
    $opt_password = $opt_password ? $opt_password : $coverityConfig->get_connect_password();
  }

  if ($opt_project && @opt_streams > 0) {
    print "You can only specify a --project OR --stream(s).  Not both.";
    pod2usage(-verbose => 1);
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

my $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v7/configurationservice")->uri('http://ws.coverity.com/v7');
$configProxy->transport->timeout(20);
$configProxy->serializer->register_ns('http://ws.coverity.com/v7', 'ws');

my $coverityWS = new Coverity::WSCoverity(username => $opt_username, password => $opt_password);


my @streamIds;

if ($opt_project) {
  my @projects = $coverityWS->get_projects($configProxy);
  #print Dumper(@projects);

  foreach my $project (@projects) {
    if ($opt_project eq $project->{'id'}->{'name'}) {

      my @streamDataObjs = ();
      if ($project->{'streams'}) {
        push @streamDataObjs, $coverityWS->to_array($project->{'streams'});
      }
      if ($project->{'streamLinks'}) {
        push @streamDataObjs, $coverityWS->to_array($project->{'streamLinks'});
      }

      foreach my $stream (@streamDataObjs) {
        push @streamIds, $stream->{'id'};
      }
    }
  }
} else {
  my @allStreams = $coverityWS->get_streams($configProxy);
  foreach my $stream (@allStreams) {
    foreach my $s (@opt_streams) {
      if ($stream->{'id'}->{'name'} eq $s) {
        push @streamIds, $stream->{'id'};
      }
    }
  }
}

print "snapshot,stream,target,version,description,date created\n";
foreach my $streamId (@streamIds) {
  #print "stream $streamId->{'name'}\n";

  my @snapshots = $coverityWS->get_snapshots_for_stream($configProxy, $streamId);
  #print Dumper(@snapshots);

  if (@snapshots) {
    my @snapshotsInfo = $coverityWS->get_snapshot_information($configProxy, \@snapshots);
    #print Dumper(@snapshotsInfo);

    my @sorted = sort { $b->{'dateCreated'} cmp $a->{'dateCreated'} } @snapshotsInfo;
    #print Dumper(@sorted);
    for my $snapshot (@sorted) {
      #print Dumper($snapshot);
      # wrap strings with double quotes so that it's easy to load into Excel
      print join(',',
        $snapshot->{'snapshotId'}->{'id'},
        '"'.$streamId->{'name'}.'"',
        '"'.$snapshot->{'target'}.'"',
        '"'.$snapshot->{'sourceVersion'}.'"',
        '"'.$snapshot->{'description'}.'"',
        $snapshot->{'dateCreated'});
      print "\n";
    }
  }
}

