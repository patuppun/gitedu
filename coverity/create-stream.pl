#!/usr/bin/perl

=pod

=head1 COPYRIGHT

(c) 2013 Coverity, Inc. All rights reserved worldwide.

=head1 NAME

get-streams.pl


=head1 SYNOPSIS

get-streams.pl [options] --project PROJECT


=head1 OPTIONS

=over 12

=item Required:

=item B<--project>

List all streams belonging to a PROJECT

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

List all streams in a given project.


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
use Coverity::WSCoverity_v8;


##############################################################################
####### Global data and configuration ########################################

my $opt_project;
my $opt_branch;
my @opt_streams;

my $opt_host;
my $opt_port;
my $opt_ssl = 0;
my $opt_username;
my $opt_password;

my $opt_coverity_config;

my $opt_help = 0;

my $debug = 0;
my $max = 0;


##############################################################################
####### Subroutines ##########################################################

sub handle_command_line_options {
  GetOptions(
    # What to operate on
    'project=s' => \$opt_project,
    'branch=s' => \$opt_branch,
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
    'max=n' => \$max,
  ) or pod2usage(-verbose => 1);
  pod2usage(-verbose => 2) if $opt_help;

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

print "ConnectURL: $connectUrl\n" if ($debug);

my $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v8/configurationservice")->uri('http://ws.coverity.com/v8');
$configProxy->transport->timeout(20);
$configProxy->serializer->register_ns('http://ws.coverity.com/v8', 'ws');

my $coverityWS = new Coverity::WSCoverity_v8(username => $opt_username, password => $opt_password, debug => $debug);

my $count = 0;

if ($opt_project) {
   foreach my $stream (@opt_streams) {
      my $spec = { name => $stream,
                   languaged => 'MIXED',
#                   roleAssignments => { roleId => {name => 'streamOwner'},
#                                        type => 'stream',
#                                        roleAssignmentType => 'user',
#                                        username => 'cpverne@ad.broadcom.com',
#                                       },
                   triageStoreId => { name => 'Default Triage Store'},
                   componentMapId => { name => $opt_project},
                  };
      $coverityWS->create_stream_in_project($configProxy, {name => $opt_project}, $spec);

   }
}
else {

}
exit;
