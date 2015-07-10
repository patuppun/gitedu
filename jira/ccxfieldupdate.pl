#!/usr/bin/perl



use CGI;
use DBI;
use Data::Dumper;

my $cgi = CGI->new();
my $param = $cgi->param('param');
my $project = $cgi->param('project');
my $product = $cgi->param('product');
my $customer = $cgi->param('customer');
my $value = $cgi->param('value');
my $field = $cgi->param('field');
my $project_list = 'SELECT distinct project FROM CCXSW_JIRA_nFeed_test.Product where idProduct !=0'; 

my @projects = &sql_query($project_list, 0);
@projects = grep { $_ ne '' } @projects;
#print "@projects \n";


if ($param) {form_info();exit;}
if ($project || $product || $customer) { form_db($project, $product, $customer, $value, $field);exit;}

main ();

sub main {

print "Content-type: text/html\n\n";

print <<"EOF";
<HTML>
<HEAD>
<TITLE>Nfeed Update</TITLE>
</HEAD>
<BODY bgcolor="#58FAF4">
<H1>Select Jira field to add new value </H1>

  <ol>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=Chip">Chip</a></li>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=Customer">Customer</a></li>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=Hardware_Board_Revision">Hardware_Board_Revision</a></li>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=OS">OS</a></li>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=Releases">Releases</a></li>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=Software_Component">Software_Component</a></li>
    <li><a href="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl?param=Target_Branch">Target_Branch</a></li>
  </ol>  
</BODY>
</HTML>
EOF

}



sub form_info {

print "Content-type: text/html\n\n";
print "<HTML>";

print   "<HEAD>";
print       "<TITLE>$param</TITLE>";
print   "</HEAD>";

print   "<BODY bgcolor='#58FAF4'> ";
print       "<H1>Provide valid values </H1>";
  
  form_data (@projects);
print "</BODY>";

print "</HTML>";


}



sub form_db {

my ($project, $chip, $customer, $value, $field) = @_;

  print "Content-type: text/html\n\n";
  print "<HTML>";
  print "<HEAD>";
  print "<TITLE>$project</TITLE>";
  print "</HEAD>";
  print "<BODY bgcolor='#58FAF4'> ";

if ($field eq "Chip") {
  print   "<H1>Connecting to Nfeed DB     ...........................</H1>";
  print   qq(<H1>Execution Sql - INSERT IGNORE INTO Chip (Project, Product, Customer, Value) VALUES ("$project", "$product", "$customer", "$value") </H1>);
  }
  print "</BODY>";
  print "</HTML>";

}


sub form_data {

  if ($param eq "Chip" || $param eq  "Hardware_Board_Revision" || $param eq "Releases") {
            print  qq(<FORM action="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl" method="GET">);
            print qq(Field: <input type="text" name="field" value="$param">);
            print qq(<br><br>);
            print qq(Project   :
            <select name="project">);
            foreach my $value (@projects) {
            print qq(<option value="$value">$value</option>);
            }
            print qq(</select>
            <br><br>
            Product   : <input type="text" name="product">
            <br><br>
            Customer  : <input type="text" name="customer">
            <br><br>
            Value     : <input type="text" name="value">
            <br><br>
            <input type="submit" value="Submit">
          </FORM>);
  }
  if ($param eq "Customer" || $param eq "Software_Component" || $param eq "Target_Branch") {
            print  qq(<FORM action="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl" method="GET">);
            print qq(Field: <input type="text" name="field" value="$param">);
            print qq(<br><br>);
            print qq(Project   :
            <select name="project">);
            foreach my $value (@projects) {
            print qq(<option value="$value">$value</option>);
            }
            print qq(</select>
            <br><br>
            Product   : <input type="text" name="product">
            <br><br>
            Value     : <input type="text" name="value">
            <br><br>
            <input type="submit" value="Submit">
          </FORM>);
  }
  if ($param eq "OS") {
            print  qq(<FORM action="http://jira-rtp-07.rtp.broadcom.com/cgi-bin/test.pl" method="GET">);
            print qq(Field: <input type="text" name="field" value="$param">);
            print qq(<br><br>);
            print qq(Project   :
            <select name="project">);
            foreach my $value (@projects) {
            print qq(<option value="$value">$value</option>);
            }
            print qq(</select>
            <br><br>
            Value     : <input type="text" name="value">
            <br><br>
            <input type="submit" value="Submit">
          </FORM>);
  }

}

sub sql_query {
      my ($sql, $return) = @_;
      my $dbh = &dbConnect;
      my $sth = $dbh->prepare("$sql");
      $sth->execute or die "SQL Error: $DBI::errstr\n";
      while (@row = $sth->fetchrow_array) { push @values, "$row[0]"; }
      return @values;

}

sub dbConnect {

        my $dsn = "DBI:mysql:CCXSW_JIRA_nFeed_test:mysql-rtp-02.rtp.broadcom.com:3306";
        my $db_user_name = 'ccxswdbreports';
        my $db_password = 'hunt3r!';
        my $dbh;
        $dbh = DBI->connect($dsn, $db_user_name, $db_password,
        {RaiseError => 1}) or die("cannot connect to DB: ".DBI::errstr. +"\n",$dbh);
        return $dbh;
        }





                                          

