#!/usr/local/bin/perl
use strict;
use Getopt::Long;
use Data::Dumper;
use Config::IniFiles;
use FindBin qw($Bin $Script);
use lib "$Bin/../perllib";

$Data::Dumper::Sortkeys = 1;

# arguments
my $debug = 0;
my $test = 0;
my $opt_project = '';

# defaults
my $gerrit_server = 'gerrit-ccxsw.rtp.broadcom.com';
my $gerrit_port = 29418;

my $gerrit_url = "ssh://$gerrit_server:$gerrit_port";
my $gerrit_config_file = "$Bin/gerrit_config.ini";

# save current directory
my $pwd = `pwd`;
chomp($pwd);

sub msg(@) { print STDERR scalar(localtime()).": ", @_; }
sub debug(@) { msg(@_) if ($debug) }
sub run(@) {
   debug("> ", @_, "\n");
   my $output = `@_ 2>&1`;
   if ($?) {
      msg($output);
   }
   else {
      debug($output);
   }

   return $?;
}

GetOptions('debug'     => \$debug,
           'test'      => \$test,
           'config=s'  => \$gerrit_config_file,
           'project=s' => \$opt_project,
           );

my $usage = "Usage: update_config.pl [--config \"file name\"] [--debug] ";

my %gerrit_config;
if (-e $gerrit_config_file) {
   tie %gerrit_config, 'Config::IniFiles', ( -file => $gerrit_config_file );
   if (@Config::IniFiles::errors) {
      msg(@Config::IniFiles::errors, "\n");
      exit 1;
   }
}
else {
   msg("Could not load config file: $gerrit_config_file\n");
   exit;
}

msg("Loading gerrit groups...\n");
my @group_data = `ssh -p $gerrit_port $gerrit_server 'gerrit ls-groups -v'`;
chomp @group_data;
my %groups;
foreach my $group (@group_data) {
   my ($group_name, $uuid, $description, $owner_group_name, $owner_group_uuid, $visible) = split("\t", $group);
   $groups{$group_name} = $uuid;
}

my @opt_projects = $opt_project ? split(',', $opt_project) : keys(%gerrit_config);
my @projects;
foreach my $opt (@opt_projects) {
   next if ($opt eq 'default');
   foreach my $project (keys(%gerrit_config)) {
      push @projects, $project if ($project =~ /^$opt$/);
   }
}

foreach my $project (sort(@projects)) {
   next if ($project eq 'default');
   msg("$project:\n");

   my $inherit_from = $gerrit_config{$project}->{inherit};

   my $config = $gerrit_config{$project}->{config};
   $config = $gerrit_config{default}->{config} unless (defined($config));

   msg("$project.config: $config\n");

   unless (defined($config)) {
      msg("Unknown config for project: $project\n");
      next;
   }

   my $owners = $gerrit_config{$project}->{owners};
   $owners = $gerrit_config{default}->{owners} unless (defined($owners));
   $owners = "$project Owners" unless (defined($owners));

   my $users  = $gerrit_config{$project}->{users};
   $users = $gerrit_config{default}->{users} unless (defined($users));
   $users = "$project Users" unless(defined($users));

   my $rules  = $gerrit_config{$project}->{rules};
   $rules = $gerrit_config{default}->{rules} unless (defined($rules));
   $rules = "" unless (defined($rules));

   my @new_config;

   if ($inherit_from) {
      # create config
      push @new_config, "[access]",
                        "\tinheritFrom = $inherit_from";
   }
   else {
      # load config
      @new_config = `cat $Bin/config/$config`;
      chomp(@new_config);

      if (-e "$Bin/config/repo/$project.config") {
         my @repo_config = `cat $Bin/config/repo/$project.config`;
         chomp(@repo_config);
         push @new_config, @repo_config;
      }

      my @branch_list;
      if (-e "$Bin/config/repo/default.branches") {
         my @default_branch_list = `cat $Bin/config/repo/default.branches`;
         chomp(@default_branch_list);
         push @branch_list, grep {$_} @default_branch_list;
      }

      if (-e "$Bin/config/repo/$project.branches") {
         my @project_branch_list = `cat $Bin/config/repo/$project.branches`;
         chomp(@project_branch_list);
         push @branch_list, grep {$_} @project_branch_list;
      }

      if ($gerrit_config{$project}->{include}) {
         my @include_config = `cat $Bin/config/$gerrit_config{$project}->{include}`;
         chomp(@include_config);
         push @new_config, @include_config;
      }

      if ($gerrit_config{$project}->{branch_rules}) {
         foreach my $branch (@branch_list) {
            my @branch_config = `cat $Bin/config/$gerrit_config{$project}->{branch_rules}`;
            chomp(@branch_config);
            foreach my $line (@branch_config) {
               if ($line =~ /^(.*?)BRANCH(.*?)$/) {
                  $line = "$1$branch$2";
               }
            }
            push @new_config, @branch_config, '';
         }
      }

      foreach my $line (@new_config) {
         if ($line =~ /^(.*? group) Users/) {
            $line = "$1 $users";
         }
         elsif ($line =~ /^(.*? group) Owners/) {
            $line = "$1 $owners";
         }
         elsif ($line =~ /^(.*branch =)$/) {
            $line = join("\n", map {"$1 $_"} map {$_ =~ /^\^/ ? "\"$_\"" : $_} @branch_list);
         }
      }
   }

   debug("New Config:\n", map {"$_\n"} @new_config, "");

   # create clone
   if (-e "$Bin/$project") {
      run("rm -rf $Bin/$project");
   }
   if (-e "$Bin/projects/$project") {
      run("rm -rf $Bin/projects/$project");
   }
   run("mkdir -p $Bin/projects/$project") && next;
   chdir("$Bin/projects/$project");
   run("git init") && next;
   run("git remote add origin ${gerrit_url}/$project") && next;
   run("git fetch origin refs/meta/config") && next;
   run("git checkout FETCH_HEAD") && next;

   # load existing config
   my @old_config = `cat $Bin/projects/$project/project.config`;
   chomp(@old_config);

   # compare old and new
   if (join("\n", @old_config) eq join("\n", @new_config)) {
      msg("Config file unchanged..\n");
   }
   else {
      # rename existing config file
      if (-e "$Bin/projects/$project/project.config") {
         rename("$Bin/projects/$project/project.config", "$Bin/projects/$project/project.config.old");
      }
      unless (open(FILE, ">$Bin/projects/$project/project.config"))
      {  
         msg("Error creating $Bin/projects/$project/project.config...\n");
         next;
      }

      # create new config file
      print FILE map {"$_\n"} @new_config;
      close(FILE);

      system("diff -u $Bin/projects/$project/project.config.old $Bin/projects/$project/project.config");

      # update groups
      msg("Updating groups file..\n");
      my %project_groups;
      foreach my $line (@new_config) {
         if ($line =~ /group (.*)/) {
            if (defined($groups{$1})) {
               $project_groups{$1} = $groups{$1};
            }
            else {
               msg("Unknown group: $1\n");
               exit 1;
            }
         }
      }

      if (open(FILE, ">$Bin/projects/$project/groups")) {
         print FILE <<EOF;
# UUID                                  	Group Name
#
EOF
         foreach my $group (sort(keys(%project_groups))) {
            print FILE "$project_groups{$group}\t$group\n";
         }
      }
   }

   # update rules
   if ($rules) {
      msg("Updating rules.pl...\n");
      run("cp $Bin/$rules ./rules.pl");
      run("git add rules.pl");
   }
   else {
      if (-e "$Bin/projects/$project/rules.pl") {
         msg("Removing rules.pl...\n");
         run("git rm $Bin/projects/$project/rules.pl");
      }
   }

   next if ($test);
   # commit and push new config
   msg("Committing new config...\n");
   run("git commit -am \"Updated config\"") && next;
   run("git push origin HEAD:refs/meta/config");
}

chdir($pwd);


