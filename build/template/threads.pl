#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings ;
 
# Get the CGI data and extract the fields
my $query = new CGI;
 
print $query->header("text/html");

print "1\n2\n3\n4\n";
 
exit ( 0 ) ;
