#!/usr/local/bin/perl

=pod

=head1 COPYRIGHT

(c) 2013 Coverity, Inc. All rights reserved worldwide.

=head1 NAME

get-defects.pl


=head1 SYNOPSIS

get-defects.pl [options] --project PROJECT (OR --stream STREAM1 --stream STREAM2 ...)


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
use JSON;

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

my $opt_project;
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
my $opt_mysql_server = '';
my $opt_dept = '';
my $opt_mergekey = 0;

my $debug = 0;
my $max = 0;
my $only = 0;
my $json = 0;
my $other = 0;

##############################################################################
####### Subroutines ##########################################################

sub handle_command_line_options {
  GetOptions(
    # What to operate on
    'project=s' => \$opt_project,
    'stream=s' => \@opt_streams,
    'filter=s' => \$opt_filter,
    'mergekey' => \$opt_mergekey,
    # reporting options
    'mysql=s' => \$opt_mysql_server,
    'dept=s' => \$opt_dept,
    'max=n' => \$max,
    'only=n' => \$only,
    'sep=s' => \$opt_sep,
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
    'json' => \$json,
    'other' => \$other,
  ) or pod2usage(-verbose => 1);
  pod2usage(-verbose => 2) if $opt_help;
  pod2usage(-verbose => 1) if (!$opt_project && !$opt_branch && @opt_streams == 0);

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

my $defectProxy = undef;
my $configProxy = undef;
my $coverityWS = undef;
my $coverityTimeout = 200;

if ($opt_version == 3) {
   $defectProxy = SOAP::Lite->proxy("$connectUrl/ws/v3/defectservice")->uri('http://ws.coverity.com/v3');
   $defectProxy->transport->timeout($coverityTimeout);
   $defectProxy->serializer->register_ns('http://ws.coverity.com/v3', 'ws');

   $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v3/configurationservice")->uri('http://ws.coverity.com/v3');
   $configProxy->transport->timeout($coverityTimeout);
   $configProxy->serializer->register_ns('http://ws.coverity.com/v3', 'ws');

   $coverityWS = new Coverity::WSCoverity_v3(username => $opt_username, password => $opt_password, debug => $debug);
}
elsif ($opt_version == 7) {
   $defectProxy = SOAP::Lite->proxy("$connectUrl/ws/v7/defectservice")->uri('http://ws.coverity.com/v7');
   $defectProxy->transport->timeout($coverityTimeout);
   $defectProxy->serializer->register_ns('http://ws.coverity.com/v7', 'ws');

   $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v7/configurationservice")->uri('http://ws.coverity.com/v7');
   $configProxy->transport->timeout($coverityTimeout);
   $configProxy->serializer->register_ns('http://ws.coverity.com/v7', 'ws');

   $coverityWS = new Coverity::WSCoverity_v7(username => $opt_username, password => $opt_password, debug => $debug);
}
elsif ($opt_version == 8) {
   $defectProxy = SOAP::Lite->proxy("$connectUrl/ws/v8/defectservice")->uri('http://ws.coverity.com/v8');
   $defectProxy->transport->timeout($coverityTimeout);
   $defectProxy->serializer->register_ns('http://ws.coverity.com/v8', 'ws');

   $configProxy = SOAP::Lite->proxy("$connectUrl/ws/v8/configurationservice")->uri('http://ws.coverity.com/v8');
   $configProxy->transport->timeout($coverityTimeout);
   $configProxy->serializer->register_ns('http://ws.coverity.com/v8', 'ws');

   $coverityWS = new Coverity::WSCoverity_v8(username => $opt_username, password => $opt_password, debug => $debug);
}

my $db = undef;
if ($opt_mysql_server && $opt_dept) {
   my $database = 'CCXSW_Coverity_Metrics';

   my $username;
   my $password;

   if (open(NETRC, "$ENV{HOME}/.netrc") || open(NETRC, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}.netrc")) {
     foreach my $line (<NETRC>) {
       chomp($line);
       if ($line =~ /^machine $opt_mysql_server\/$database login (.*?) password (.*?)$/) {
         $username = $1;
         $password = $2;
         last;
       }
     }
   }
   unless ($username) {
      print "No username selected.\n";
      exit 1;
   }

   use DB::COVERITY_METRICS;

   $db = DB::COVERITY_METRICS->new(server => $opt_mysql_server,
                                   database => $database,
                                   username => $username,
                                   password => $password,
                                   debug => $debug,
                                   test => 0);
}

if ($opt_project) {
  my @projects;
  # if '*' is specified, load all available projects on the server
  if ($opt_project eq '*') {
     my @project_data = $coverityWS->get_projects($configProxy, {});
     foreach my $project (@project_data) {
        push @projects, $project->{id}->{name};
     }
  }
  else {
      @projects = split(',', $opt_project);
  }
  print Dumper(\@projects) if ($debug);
  my %defects;

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

  # iterate through selected projects and store defect information
  foreach my $project (@projects) {
     print STDERR "$project\n";
     my @defects = $coverityWS->get_merged_defects_for_project($defectProxy, {name => $project}, \@filter);

     foreach my $defect (@defects) {
#        print Dumper($defect) if ($debug);

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

        $defects{$defect->{cid}} = {} unless (defined($defects{$defect->{cid}}));
        $defects{$defect->{cid}}->{$project} = $defect;

#        print Dumper($defects{$defect->{cid}}) if ($debug);
     }
  }

  if ($json) {
     print to_json(\%defects, {pretty => 1});
  }
  else {
     if ($opt_mergekey) {
        print join($opt_sep, qw(cid projects date lastfixed checker subchecker impact component file function status severity mergekey)), "\n";
     }
     else {
        print join($opt_sep, qw(cid projects date lastfixed checker subchecker impact component file function status severity)), "\n";
     }

     # iterate through all found issues
     my $count = 0;
     foreach my $cid (sort {$a <=> $b} keys(%defects)) {
        next if ($only && $cid != $only);
        my $defect = $defects{$cid};
        print Dumper($defect) if ($debug);
        my @projects = sort(keys(%{$defect}));
        my $first_project = $projects[0];

        unless ($other)
        {
           # ignore files in other component
           next if ($defect->{$first_project}->{componentName} =~ /\.other$/i);
        }

        # determine the status of all occurances of this issue
        my @status = grep {$_} map {$defect->{$_}->{attributes}->{DefectStatus} || $defect->{$_}->{status}} @projects;

        # determine the severity of all occurances of this issue
        my @severity = grep {$_} map {$defect->{$_}->{attributes}->{Severity} || $defect->{$_}->{severity}} @projects;

        # pull data that is common to all occurances
        my @row = ($cid, 
                   join(',', @projects),
                   $defect->{$first_project}->{firstDetected},
                   $defect->{$first_project}->{lastFixed},
                   $defect->{$first_project}->{checkerName},
                   $defect->{$first_project}->{checkerSubcategory},
                   $defect->{$first_project}->{checkerImpact},
                   $defect->{$first_project}->{componentName},
                   $defect->{$first_project}->{filePathname},
                   $defect->{$first_project}->{functionDisplayName},
                   join(',', @status),
                   join(',', @severity),
                  );
        push @row, $defect->{$first_project}->{mergeKey} if ($opt_mergekey);

        @row = map {$_ =~ /,/ ? "\"$_\"" : $_} @row if ($opt_sep eq ',');
        print join($opt_sep,@row),"\n";

         if ($db) {
            my @results = $db->Query('Data', Dept => $opt_dept,
                                             Id => $cid,
                                             );
            if (@results && defined($results[0]) ) {
               print Dumper(\@results) if ($debug);
               my $index = $results[0]->{idData};
               my $rc = $db->Update('Data', idData => $index,
                                            Projects => join(',', @projects),
                                            Opened => $defect->{$first_project}->{firstDetected},
                                            LastFixed => $defect->{$first_project}->{lastFixed},
                                            Checker => $defect->{$first_project}->{checkerName},
                                            Subchecker => $defect->{$first_project}->{checkerSubcategory},
                                            Impact => $defect->{$first_project}->{checkerImpact},
                                            Component => $defect->{$first_project}->{componentName},
                                            File => $defect->{$first_project}->{filePathname},
                                            Function => $defect->{$first_project}->{functionDisplayName},
                                            Status => join(',', @status),
                                            Severity => join(',', @severity),
                                   );
               last if ($rc);
            }
            else {
               my $rc = $db->Insert('Data', Dept => $opt_dept,
                                            Id => $cid,
                                            Projects => join(',', @projects),
                                            Opened => $defect->{$first_project}->{firstDetected},
                                            FirstFixed => $defect->{$first_project}->{lastFixed},
                                            LastFixed => $defect->{$first_project}->{lastFixed},
                                            Checker => $defect->{$first_project}->{checkerName},
                                            Subchecker => $defect->{$first_project}->{checkerSubcategory},
                                            Impact => $defect->{$first_project}->{checkerImpact},
                                            Component => $defect->{$first_project}->{componentName},
                                            File => $defect->{$first_project}->{filePathname},
                                            Function => $defect->{$first_project}->{functionDisplayName},
                                            Status => join(',', @status),
                                            Severity => join(',', @severity),
                                    );
            }
         }

        $count++;
        exit if ($max && $count >= $max);
     }
   }
} 
else {
   foreach my $stream (@opt_streams) {
      my @defects = $coverityWS->get_merged_defects_for_stream($defectProxy, $stream, {});
   }
}
exit;
