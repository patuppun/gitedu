#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings;
use ElectricCommander;
use XML::XPath;
 
# Get the CGI data and extract the fields
my $query = new CGI;
 
print $query->header("text/html");

my $ec = ElectricCommander->new();
my $userName = $ec->getProperty("/myUser/userName")->findvalue("//value");

print "test\n";
 
exit ( 0 ) ;
