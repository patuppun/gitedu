#!/bin/sh
exec "$COMMANDER_HOME/bin/ec-perl" -x "$0" "${@}"
#!perl
 
use CGI;
use warnings ;
 
# Get the CGI data and extract the fields
my $query = new CGI;
 
print $query->header("text/html");

# determine what the current host is
my $host = `hostname`;
chomp($host);

if ($host =~ /eca-(.*?)-/) {
   $host = uc($1);
}
else {
   $host = 'RTP';
}

# print the current host at the top
print "$host\n";

# print the rest of the hosts
foreach my $other (sort(qw(RTP AND IRV HYD RIC))) {
   print "$other\n" unless ($host eq $other);
}
 
exit ( 0 ) ;
