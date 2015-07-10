#!/usr/bin/perl
#!/usr/local/bin/perl


#use strict;
#use warnings;
use CGI;
use DBI;
use Data::Dumper;
use Net::LDAP;
use Mail::Mailer;

my $cgi = CGI->new();
my $param = $cgi->param('param');
my $project = $cgi->param('project');
my $product = $cgi->param('product');
my $customer = $cgi->param('customer');
my ($userfile, $usermsg) = split (',', $cgi->param('userfile'));
my @customers= split(',', $customer);
@customers= grep(s/^\s*//g, @customers);
@customers= grep(s/\s*$//g, @customers);
my $confirm= $cgi->param('confirm');
my $table_key= $cgi->param('table_key');
my $value = $cgi->param('value');
my @newfieldvalues= split(',', $value);
@newfieldvalues = grep(s/^\s*//g, @newfieldvalues);
@newfieldvalues = grep(s/\s*$//g, @newfieldvalues);

my $field = $cgi->param('field');
my $host = "jira-rtp-07.rtp.broadcom.com";
my $env= $cgi->param('env');
my $db;

if ($env eq "stage") {$db = "CCXSW_JIRA_nFeed_test";}
    else {  $db = "CCXSW_JIRA_nFeed";}
  
my $log_dir = "/projects/ccxsw_jira/product_dblogs"; 
  mkdir ("$log_dir/$remoteUser");
  my $logfile = "$log_dir/$remoteUser/nfeed_dbchange.log";
  open (LOG, ">>", "$logfile" ) or die "Couldn't open file: $!";

my $remoteUser = "$ENV{REMOTE_USER}";
my $project_list = "SELECT distinct project FROM $db.Product where idProduct !=0"; 
my @projects = &sql_fetch($project_list, 0);
#my $host = "jira-rtp-07.rtp.broadcom.com";



my $text = qq(
    <H3>$param : Customization Submission </h3>
    <P>For current $param Product Line Database values <a href="http://$host/cgi-bin/ccxfieldupdate.pl?table_key=$param&project=$project">Click Here</a> </p>
    <P>Based on previous seletion, Grey Fields are not modifiable.</p>
    <p>
        1.  <b>Product</b> : Update the Product selection, if needed <br>
        2.  <b>Customer</b>: Enter a single Customer or Provide a series of values seaprated by a comma<br> <br>
            &nbsp&nbsp&nbsp Example input:  Acme, Ironworks <br>
            &nbsp&nbsp&nbsp Note:  Values added to Customer = Broadcom will be presented for all Customers.<br>
            &nbsp&nbsp&nbsp Note:  Entered values must match a pre-existing Customer name.<br><br>
            );
my $text1 = qq(
    <H3>$param : Customization Submission </h3>
    <P>For current $param Product Line Database values <a href="http://$host/cgi-bin/ccxfieldupdate.pl?table_key=$param&project=$project">Click Here</a> </p>
    <P>Based on previous selection, Grey Fields are not modifiable.</p> 
    <p>
    1.  <b>Product</b> : Update the Product selection, if needed <br>
    2.  <b>Value</b>: Enter a single Customer or Provide a series of values seaprated by a comma<br> <br>
);

my %help ;

$help{'main'} = qq(
    <H3>&nbspWELCOME:  &nbsp$ENV{REMOTE_USER}</H3>
    <P>This is the <b>CCX SW Product Line Database</b>. This front end provides a central repository for maintaining product specific information for access via various  tools.  This tool allows product administrators to directly update product data.  To begin, select the area identifier or JIRA project identifier from the list at the left. </p>
    <P>The tool currently provides services to the following tools. </P>
    <li><b>CCXSW JIRA</b></li> </ul>
    <P> &nbspTo request additional help, email  <a href="mailto:ccxsw-jira-admin-list\@broadcom.com?subject=CCXSW JIRA Self Managed nFeed Custom Fields support..!" style="color:black" >ccxsw-jira-admin-list</a> </P>
  );
$help{'field'} = qq(
  <H3>Database Tables</H3>
  <p><b>These tables are used to present field value options in the associated CCXSW JIRA Project.  Reference CCXSW JIRA for additional help on field usage.</b></p>
  <table border="1">
  <tr><th>Table Name</th> <th>CCXSW Fields Affected</th></tr>
  <tr><td>Chip</td> <td><ul> <li>Chip</li> <li>Fixed in Chip Revision</li> </ul></td></tr>
  <tr><td>Customer</td> <td><ul> <li>Customer</li> <p>This table is used to provide a </b>SECONDARY KEY</b> for presenting values in CCXSW JIRA.<p> </ul></td></tr>
  <tr><td>Document</td> <td><ul> <li>Documents</li></ul></td></tr>
  <tr><td>Hardware_Board_Revision</td> <td><ul> <li>Hardware / Board Revision</li></ul></td></tr>
  <tr><td>OS</td> <td><ul> <li>OS</li></ul></td></tr>
  <tr><td>Package</td> <td><ul> <li>Package</li></ul></td></tr>
  <tr><td>Product</td> <td><ul> <li>Product</li> <p>This table is used to provide a <b>PRIMARY KEY</b> for presenting values in CCXSW JIRA<p> <p>Product values may only be added by CCXSW JIRA administrators.</p></ul></td></tr>
  <tr><td>Releases</td> <td><ul> <li>Releases Found</li> <li>Releases Release</li> <li>Releases Fixed</li></ul></td></tr>
  <tr><td>Software Component</td> <td><ul> <li>Software Component</li></ul></td></tr>
  </table>
  );
$help{'Chip'} = qq(
   $text
   3.  <b>Value</b>   : Enter the value(s) to be added, separated by a comma.<br><br>
       &nbsp&nbsp&nbsp Example input: 5750_A0,  53012_A0 (Northstar) <br> 
      &nbsp&nbsp&nbsp Note:  The expected format is a chip number concatenated by a revision number. A code name may optionally be included in parentheses. Chip revision numbers are expected to have formats such as A0, B0, C0, A1, B1, etc.  Each value in the list of chip numbers should exactly matches the values selectable in other Broadcom databases, such as CSP and INGJIRA. If you are unsure of a chip name or revision, coordinate with the appropriate Chip organization.<br> <br>
  </p>);
  $help{'Releases'} = qq(
    $text
    3.  <b>Value</b>   : Enter the value(s) to be added, separated by a comma.<br><br>
      &nbsp&nbsp&nbsp Example input:  Example input:   AVB-1.4.0,  AVB-1.4.x<br>
      &nbsp&nbsp&nbsp Note:  The expected format is a <Prefix>-<3 digit release number>.   A \".x\" release number is used to identify issues to be tracked against a subsequent release. The \".x\" release number is expected to be removed when the subsequent release is committed.
    </p>);
  $help{'Hardware_Board_Revision'} = qq(
    $text
    3.  <b>Value</b>   : Enter the value(s) to be added, separated by a comma.<br><br>
      &nbsp&nbsp&nbsp Example input:  Example input: BCM957406A060 (NIC1), BCM958100K (Jayton)<br>
    </p>);

  $help{'Customer'}= qq(
      $text1
      &nbsp&nbsp&nbsp Example input:  Acme, Ironworks <br>
    </p>);
  $help{'Target_Branch'}= qq(
      $text1
      &nbsp&nbsp&nbsp Example input:   <br>
    </p>);
  $help{'Document'} = qq(
      $text1
      &nbsp&nbsp&nbsp Example input:  Functional Specification, User's Guide <br>
    </p>);
  $help{'OS'} = qq(
      $text1
      &nbsp&nbsp&nbsp Example input:  Red Hat EL 6.1,  Linux 2.6 <br>
      &nbsp&nbsp&nbsp A customary format is "<OS> <version> [service pack]", where service pack is required for certain product lines.  The format of service pack for certain product lines is represented as SP1, SP2, etc.
    </p>);
  $help{'Package'} = qq(
      $text1
      &nbsp&nbsp&nbsp Example input:  Linux Kernel,  HAL, Android Application <br>
      &nbsp&nbsp&nbsp Note:  This table is optionally populated by a product line.
    </p>);
  $help{'Software_Component'} = qq(
      $text1
      &nbsp&nbsp&nbsp Example input:  Policer,  WiFi Driver  <br>
    </p>);
my %tables = (
      Chip  => "SELECT Project,Product,Customer,Value FROM CCXSW_JIRA_nFeed_test.Chip where Project = \"$project\" ",
      Hardware_Board_Revision => "SELECT Project,Product,Customer,Value FROM CCXSW_JIRA_nFeed_test.Hardware_Board_Revision where Project = \"$project\" ",
      Releases => "SELECT Project,Product,Customer,Value FROM CCXSW_JIRA_nFeed_test.Releases where Project = \"$project\" ",
      Customer => "SELECT Project,Product,Value FROM $db.Customer where Project = \"$project\" ",
      Package => "SELECT Project,Product,Value FROM $db.Package where Project = \"$project\" ",
      Target_Branch => "SELECT Project,Product,Value FROM $db.Target_Branch where Project = \"$project\" ",
      Software_Component  => "SELECT Project,Product,Value FROM $db.Software_Component where Project = \"$project\" ",
      Product => "SELECT Project,Value FROM $db.Product where Project \"$project\" ",
      Document   => "SELECT Project,Value FROM $db.Document where Project = \"$project\" ",
      OS => "SELECT Project,Value FROM $db.OS where Project = \"$project\" "
      );

my $header = "CXSW JIRA Product Line Database";
my $timestamp = localtime(time);

@projects = grep { $_ ne '' } @projects;
@projects = grep { $_ ne "Client Security" } @projects;
my $logfile;

#main

if ($field) {
    print LOG  "$timestamp : $remoteUser on $env: Selected $field  \n";
    form_db($project, $product, $customer, $value, $field);exit;}
elsif($param && $project) {
    my $product_list = "SELECT value FROM $db.Product where Project = \"$project\"";
    my @products = &sql_fetch($product_list, 0);
    form_info(@products);
  exit;
  }
elsif ($table_key  && $project) {field_table($table_key, 0) ;exit;}
elsif ($project) {select_filed();exit;}
elsif($confirm) {
    form_confirm();exit;}    
  else {main();
}


sub main {
  html_layout ('main', 0);
  header ("$header", 0);
    print qq(<div id = "nav" > );
    print qq(<FORM action="http://$host/cgi-bin/ccxfieldupdate.pl" method="POST">);
    print qq(<h4>CCXSW JIRA Environment </h4>);
    print qq(ENV :  <select name="env">);
    print qq(<option value="stage">STAGE</option>
    <option value="prod">PROD</option> </select>);
    print qq( <h4>CCXSW Project </h4> );
    print qq(Project   :
    <select name="project">);
  foreach my $value (@projects) {
    print qq(<option value="$value">$value</option>);
    }
    print qq(</select>
      <br><br>
      <input type="submit" value="Next">
      </FORM>);
  section($help{'main'}, 0);
    print qq(<br><br>);
    print qq(<br><br>);
    print qq(<br>);
  footer('Authorized Use Only. Use of this system must be in accordance with our Acceptable Use Policy located at http://accept-use.broadcom.com.
  Activity on this system is subject to monitoring and logging.',0);
}

sub select_filed {
  print LOG  "$timestamp : $remoteUser on $env: Login  \n";
  print LOG  "$timestamp : $remoteUser on $env: Selected Project $project ........\n";
  html_layout ('fields', 0);
  header ("$header", 0);
  #header ('CCXSW nFeed DB Admin', 0);
  print qq(<div id = "nav" > );
  print qq(<br>);
  print qq(<H4>Product Database Table</H4>);
  print qq( <ol>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Chip&project=$project&env=$env">Chip</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Customer&project=$project&env=$env">Customer</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Document&project=$project&env=$env">Document</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Hardware_Board_Revision&project=$project&env=$env">Hardware_Board_Revision</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=OS&project=$project&env=$env">OS</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Package&project=$project&env=$env">Package</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Releases&project=$project&env=$env">Releases</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Software_Component&project=$project&env=$env">Software_Component</a></li>
    <li><a href="http://$host/cgi-bin/ccxfieldupdate.pl?param=Target_Branch&project=$project&env=$env">Target_Branch</a></li>
  </ol>);
  section($help{'field'} , 0);
  print qq(<br><br>);
  print qq(<br><br>);
  print qq(<br><br>);
  footer('Authorized Use Only. Use of this system must be in accordance with our Acceptable Use Policy located at http://accept-use.broadcom.com.
  Activity on this system is subject to monitoring and logging.',0);

}


sub form_info {
  print LOG  "$timestamp : $remoteUser on $env: Selected CCXSW JIRA Field $param .......\n";
  my @products = @_;
    html_layout ("$param", 0);
     header ("$header", 0);
    print qq(<div id = "nav" > );
    form_data (@products);
    print qq(<br><br>);
    print qq(<br><br>);
    print qq(<br><br>);
  footer('Authorized Use Only. Use of this system must be in accordance with our Acceptable Use Policy located at http://accept-use.broadcom.com.
  Activity on this system is subject to monitoring and logging.',0);
}


sub form_data {

my @products = @_;

if ($param eq "Chip" || $param eq  "Hardware_Board_Revision" || $param eq "Releases") {
  print qq(<FORM action="http://$host/cgi-bin/ccxfieldupdate.pl" method="POST">);
  print qq(Field: <input type="text" name="field" value="$param"  readonly="readonly" style="color: #424242" >);
  print qq(<br><br>);
  print qq(Project: <input type="text" name="project" value="$project"  readonly="readonly" style="color: #424242" >);
  print qq(<br><br>);
  print qq(Product   :
  <select name="product">);
  foreach my $value (@products) {
    print qq(<option value="$value">$value</option>);
    }
  print qq(</select>
    <br><br>
  Customer  : <input type="text" name="customer">
    <br><br>
  Value     : <input type="text" name="value">
  <br><br>
      <input type="hidden" name="env" value="$env" />
  <input type="submit" value="Submit">
  </FORM>);
    section($help{$param}, 0);
  }
if ($param eq "Customer" || $param eq "Software_Component" || $param eq "Target_Branch" || $param eq "Package") {
  print  qq(<FORM action="http://$host/cgi-bin/ccxfieldupdate.pl" method="POST">);
  print qq(Field: <input type="text" name="field" value="$param" readonly="readonly" style="color: grey" >);
  print qq(<br><br>);
  print qq(Project: <input type="text" name="project" value="$project" readonly="readonly"  style="color: grey" >);
  print qq(<br><br>);
  print qq(Product   :
  <select name="product">);
  foreach my $value (@products) {
  print qq(<option value="$value">$value</option>);
  }
  print qq(</select>
  <br><br>
  Value     : <input type="text" name="value">
  <br><br>
      <input type="hidden" name="env" value="$env" />
  <input type="submit" value="Submit">
  </FORM>);
    section($help{$param}, 0);
  }
if ($param eq "OS" || $param eq "Document") {
  print  qq(<FORM action="http://$host/cgi-bin/ccxfieldupdate.pl" method="POST">);
  print qq(Field: <input type="text" name="field" value="$param" readonly="readonly">);
  print qq(<br><br>);
  print qq(Project: <input type="text" name="project" value="$project" readonly="readonly" style="color: grey">);
  print qq(<br><br>);
  print qq(</select>
  Value     : <input type="text" name="value">
  <br><br>
      <input type="hidden" name="env" value="$env" />
  <input type="submit" value="Submit">
  </FORM>);
    section($help{$param}, 0);
  }

}

sub form_db {
#my ($project, $product, $customer, $value, $field) = @_;
  my $remoteUser_uc = uc($remoteUser); 
  my $date = `date +%Y%m%d%H%M%S`;
  chomp ($date);
  my $currentCustomer_list = "SELECT value FROM $db.Customer where project = \"$project\" and Product = \"$product\" "; 
  my @currentCustomers = &sql_fetch($currentCustomer_list, 0);
  mkdir ("$log_dir/$remoteUser");
  my $sqlQuerryfile = "$log_dir/$remoteUser/$remoteUser$date$env.data";
  open (DATA, ">>", "$sqlQuerryfile" ) or die "Couldn't open file: $!";
  my $email_msg = "$log_dir/$remoteUser/$remoteUser$date$env.emailmsg";
  open (EMAIL, ">>", "$email_msg" ) or die "Couldn't open file: $!";

      print EMAIL "Your new CCXSW JIRA Product-Line Variable Field request has been completed. \n";
      print EMAIL "If you experience or determine that the request has not been adequately fulfilled send a message to ccxsw-jira-admin-list\@broadcom.com \n\n\n\n";
      print EMAIL "As a Reminder your request was to add following values to $field \n\n";
      print EMAIL "ENVIRONMENT : $env\n\n";

      html_layout ("$project", 0);
     header ("$header", 0);
      #print qq(<div id = "nav" > );
      print  qq(<FORM action="http://$host/cgi-bin/ccxfieldupdate.pl" method="POST">);
      #print qq(<p>$db , $host</p>);

if ($field eq "Chip" || $field eq "Hardware_Board_Revision" || $field eq "Releases") {
  print LOG  "$timestamp : $remoteUser on $env: Provided Customers : @customers .......\n";
  print LOG  "$timestamp : $remoteUser on $env: Provided new Values : @newfieldvalues .......\n";
    foreach my $customer (@customers) {
      if (! grep /$customer/, @currentCustomers) {
      print qq(<p> Customer :$customer<p>);
      print   qq(<p>$customer did not match pre-existing Customer names, If new Customer please add it in Customer Tabel first.  );
      next;
      }
      print EMAIL "            $project-> $product->$customer->$field : @newfieldvalues \n\n";
      print qq(<p> Customer :$customer<p>);
      print   qq(<p>Adding new $field value  for Project: $project and Product: $product );
      print qq(<br>);
    foreach my $newfieldvalues (@newfieldvalues) {
      #print LOG  "$timestamp : INSERT IGNORE INTO $field (Project, Product, Customer, Value) VALUES (\"$project\", \"$product\", \"$customer\", \"$newfieldvalues\")\n";
      print DATA "INSERT IGNORE INTO $field (Project, Product, Customer, Value) VALUES (\"$project\", \"$product\", \"$customer\", \"$newfieldvalues\")\n";
      print qq(<br>);
      print qq( $newfieldvalues);
      }
      }
  }
elsif ($field eq "Package" || $field eq "Software_Component" || $field eq "Customer" || $field eq "Target_Branch") {
  print LOG  "$timestamp : $remoteUser on $env: Provided new Values : @newfieldvalues .......\n";
      print EMAIL "            $project->$product->$field :  @newfieldvalues \n\n";
      print   qq(<p>Adding new $field value  for Project: $project Product: $product );
      print qq(<br>);
    foreach my $newfieldvalues (@newfieldvalues) {
      #print LOG  "$timestamp : INSERT IGNORE INTO $field (Project, Product, Value) VALUES (\"$project\", \"$product\", \"$newfieldvalues\")\n";
      print DATA "INSERT IGNORE INTO $field (Project, Product, Value) VALUES (\"$project\", \"$product\", \"$newfieldvalues\")\n";
      print qq(<br>);
      print qq($newfieldvalues);
        }
  }
elsif ($field eq "OS"  || $field eq "Document") {
  print LOG  "$timestamp : $remoteUser on $env: Provided new Values : @newfieldvalues .......\n";
      print EMAIL "            $project->$field : @newfieldvalues \n\n";
      print   qq(<p>Adding new $field value  for Project :$project );
      print qq(<br>);
    foreach my $newfieldvalues (@newfieldvalues) {
      #print LOG  "$timestamp : INSERT IGNORE INTO $field (Project, Value) VALUES (\"$project\", \"$newfieldvalues\")\n";
      print DATA "INSERT IGNORE INTO $field (Project, Value) VALUES (\"$project\", \"$newfieldvalues\")\n";
      print qq(<br>);
      print qq($newfieldvalues);
        }
  }
      print qq(<br><br>);
  print qq(
      <input type="hidden" name="confirm" value="confirm" />
      <input type="hidden" name="env" value="$env" />
      <input type="hidden" name="userfile" value="$remoteUser$date$env.data,$remoteUser$date$env.emailmsg" />
      <input type="submit" value="Confirm">
      </FORM>);
      #print LOG  "$timestamp : $remoteUser on $env: User provided vlaues recorded in $remoteUser$date.data,$remoteUser$date.emailmsg \n";
      print qq(<br><br>);
      print qq(<br><br>);
      print qq(<br><br>);
  footer('Authorized Use Only. Use of this system must be in accordance with our Acceptable Use Policy located at http://accept-use.broadcom.com.
  Activity on this system is subject to monitoring and logging.',0);
    Close (DATA);
    Close (EMAIL);
}



sub form_confirm {
    print LOG  "$timestamp : $remoteUser on $env: provide new nFeed values and Confirm $remoteUser$date.data\n";
    print LOG  "$timestamp : $remoteUser on $env: Confirmed values / Processing data for $userfile .....  \n";
  my $sqlQuerryfile = "$log_dir/$remoteUser/$userfile";
  open (DATA, "<", "$sqlQuerryfile" ) or die "Couldn't open file: $!";
    chomp(my @lines = <DATA>);
  html_layout ('main', 0);
     header ("$header", 0);
    #print qq(<div id = "nav" > );
    print qq(<p> All requested values have been added to Product-Line DB. A confirmation email has been sent to applicaple stakeholders.</p>);
    print qq(<p> Send any inquiries to CCXSW JIRA ADMIN </p>);
    print qq (<FORM><INPUT Type="BUTTON" Value="Home Page" Onclick="window.location.href='http://$host/cgi-bin/ccxfieldupdate.pl'"> </FORM>);
  foreach my $line (@lines) {
    print LOG  "$timestamp : $remoteUser on $env: Executing sql querry $line\n";
      sql_do($line,0);                
  } 
    print qq(<br><br>);
    print qq(<br><br>);
    print qq(<br>);
  my $cmd = "/bin/mail -s 'CCXSW JIRA Product-Line DB Confirmation..!' -c nareshu\@broadcom.com  -r ccxsw-jira-admin-list\@broadcom.com  $remoteUser\@broadcom.com  < $log_dir/$remoteUser/$usermsg";
    system ($cmd) or die "Couldn't send email: $!";
  footer('Authorized Use Only. Use of this system must be in accordance with our Acceptable Use Policy located at http://accept-use.broadcom.com.
  Activity on this system is subject to monitoring and logging.',0);
    Close (DATA);
    exit;
}


sub sql_do {
  my @values;
  my ($querry, $return) = @_;
  my $dbh = &dbConnect;
  #my $sth = $dbh->do("$querry") or die "<p>Couldn't execute sql: $sql $dbh->errstr+</p>";
}

sub sql_fetch {
  my @values;
  my @row;
  my ($querry, $return) = @_;
  my $dbh = &dbConnect;
  my $sth = $dbh->prepare("$querry");
  $sth->execute or die "SQL Error: $DBI::errstr\n";
    while (@row = $sth->fetchrow_array) { push @values, "$row[0]"; }
  return @values;
}


sub dbConnect {

  my $dsn = "DBI:mysql:$db:mysql-rtp-02.rtp.broadcom.com:3306";
  my $db_user_name = 'ccxswdbreports';
  my $db_password = 'hunt3r!';
  my $dbh;
  $dbh = DBI->connect($dsn, $db_user_name, $db_password,
    {RaiseError => 1}) or die("cannot connect to DB: ".DBI::errstr. +"\n",$dbh);
  return $dbh;
}


sub field_table {
  
  my ($key, $return) = @_;
  html_layout ('main', 0);
  header ("$header", 0);
  
  print qq (<table border=\"1\">\n);
  
  if ($key eq "Chip" || $key eq "Hardware_Board_Revision" || $key eq "Releases") {
    print qq(<tr><th>Project</th> <th>Product</th> <th>Customer</th><th>Value</th></tr>\n);
      }elsif ($key eq "Customer" || $key eq "Package" || $key eq "Software_Component") {
    print qq(<tr><th>Project</th> <th>Product</th> <th>Value</th></tr>\n);
        }else {
    print qq(<tr><th>Project</th> <th>Value</th></tr>\n);
        }
  &sql_table_fetch($tables{"$key"}, $key);
    print qq (</table>);
  
    print qq(<br><br>);
    print qq(<br><br>);
    print qq(<br>);
  footer('Authorized Use Only. Use of this system must be in accordance with our Acceptable Use Policy located at http://accept-use.broadcom.com.
  Activity on this system is subject to monitoring and logging.',0);
  
}


sub sql_table_fetch {
  my @values;
  my @row;
  my ($querry, $key) = @_;
print qq(<p>$querry</p>);
  my $dbh = &dbConnect;
  my $sth = $dbh->prepare("$querry");
  $sth->execute or die "SQL Error: $DBI::errstr\n";
  while (@row = $sth->fetchrow_array) {
      if ($key eq "Chip" || $key eq "Hardware_Board_Revision" || $key eq "Releases") {
        print qq(<tr><td>$row[0]</td> <td>$row[1]</td> <td>$row[2]</td><td>$row[3]</td></tr> \n);
        }elsif ($key eq "Customer" || $key eq "Package" || $key eq "Software_Component") {
          print qq(<tr><td>$row[0]</td> <td>$row[1]</td> <td>$row[2]</td></tr> \n);
        }else {print qq (<tr><td>$row[0]</td> <td>$row[1]</td></tr> \n);
        }
        }
}



sub html_layout {

my ($text,$return) = @_;
  print "Content-type: text/html\n\n";
  print "<HTML>";
  print "<HEAD>";
  print "<TITLE>$text</TITLE>";
  print "</HEAD>";
  print "<BODY bgcolor='#eeeeee'> ";
  #print "<BODY bgcolor='#FFFFFF'> ";
  print qq( <style>
#header{
    background-color:#4a721d;
    color:white;
    text-align:center;
    padding:3px;
  }
#nav {
    height:650px;
    width:400px;
    float:left;
    padding:5px;
  float:left;
  }
#section{
    width:600px;
    float:right;
    padding:5px;
  }
#footer {
  background-color:#4a721d;
  color:white;
  clear:both;
  text-align:left;
  }

  </style>
  );
}

##   background-color:#CC092F;
sub header {
  my ($text,$return) = @_;
  print qq (<div id="header"> <H1>$text</H1>  </div>);
}

sub footer {
  my ($text,$return) = @_;
  print qq (<div id="footer"> <p>$text<p></div>);
  print qq(</BODY> </HTML>);
}

sub section {
  my ($text,$return) = @_;
    print qq(</div id = "section">);
    print qq(<br>);
    print  qq( $text
    </div>);
}


