#!/usr/local/bin/perl
use Getopt::Long;
use FindBin qw($Bin $Script);

my $dept = '';
my $debug = 0;
my $max = 0;
my $mysql = '';

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }


GetOptions('debug'     => \$debug,
           'dept=s'    => \$dept,
           'max=n'     => \$max,
           'mysql=s'   => \$mysql,
           );

my %config = (WLAN         => {config => 'coverity-cov-rtp-03.xml',
                               project => 'ESDK,UAP',
                               filter => '',
                               version => 8,
                              },
              SOC          => {config => 'coverity-cov-sj1-04.xml',
                               project => '*',
                               filter => '',
                               version => 3,
                              },
              SBX          => {config => 'coverity-cov-sj1-09.xml',
                               project => 'sdk',
                               filter => 'componentIdList=sdk.sbx,sdk.xcore caladan3,sdk.xcore;componentIdExclude=false',
                               version => 7,
                              },
              CTRL         => {config => 'coverity-cov-irv-09.xml',
                               project => '*',
                               filter => '',
                               version => 7,
                              },
              BCA_1        => {config => 'coverity-cov-sj1-01.xml',
                               project => 'RefSW,Applibs',
                               filter => '',
                               version => 7,
                              },
              BCA_2        => {config => 'coverity-cov-sj1-01.xml',
                               project => 'Android,CFE',
                               filter => '',
                               version => 7,
                              },
              BCA_3        => {config => 'coverity-cov-sj1-01.xml',
                               project => 'DirecTV-C61K,DirecTV-H44,DirecTVCDINexus-C31,DirecTVCDINexus-HR44,EchostarEV9400,EchostarVIP,EchostarXiP,EchostarXiP112,EchostarXiP913,EchostarXiP913-Greene,EchostarXiP913-Netflix,EchostarXip110,EchostarXip110RC,EchostarXip813,ComcastRDK-XG1,ComcastRDK-XG1-DTCPIP',
                               filter => '',
                               version => 7,
                              },
              BCAISR       => {config => 'coverity-cov-tlva-02.xml',
                               project => 'L1_code',
                               filter => '',
                               version => 7,
                              },
              SDK          => {config => 'coverity-cov-sj1-09.xml',
                               project => 'sdk',
                               filter => '',
                               version => 7,
                              },
              PHY          => {config => 'coverity-cov-sj1-10.xml',
                               project => 'BCM59111_Nuvoton,BCM59111_STMicro',#,BCM59121_Nuvoton,BCM59121_STMicro',
                               filter => '',
                               version => 7,
                              },

              BSC_NDS_CDI  => {config => 'coverity-stb-brsa-03.xml',
                               project => 'CDI',
                               filter => '',
                               version => 7,
                              },
              BSC_OPENTV   => {config => 'coverity-cov-bei-01.xml',
                               project => 'OPENTV_HON,CMC',
                               filter => '',
                               version => 7,
                              },
             CABMOD        => {config => 'coverity-cov-atl.xml',
                               project => 'INT_ChipRlsPC20_3385_bcm93385sms_pc20edva_comcast,INT_ProdRlsPC15Ver39211x-bcm93383wvg,INT_ProdRlsPC20Ver57x-bcm933843usg',
                               filter => '',
                               version => 7,
                              },
             );

my $dept_config = lc("coverity-$dept.xml");
my $filter = '';
my $version = 6;
if (defined($config{$dept})) {
   $dept_config = $config{$dept}->{config} || $dept_config;
   $project = $config{$dept}->{project} || $project;
   $filter = $config{$dept}->{filter} || $filter;
   $version = $config{$dept}->{version} || $version;
}
else {
   print "ERROR: No department specified ($dept).";
}

my $debug_opt = ($debug) ? '--debug' : '';
my $max_opt = ($max) ? "--max $max" : '';
my $mysql_opt = ($mysql) ? "--mysql \"$mysql\"" : '';

my $cmd = "$Bin/get-defects.pl --config \"/home/ccxswbuild/$dept_config\" --filter \"$filter\" --version \"$version\" --sep \"\|\" --project \"$project\" $max_opt $debug_opt $mysql_opt --dept $dept";
print "> $cmd\n" if ($debug);
print `$cmd`;

exit;
