#!/usr/bin/env perl

#
# Copyright (c) 2013 <chris at theclonchs dot com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

use strict;

use DBI;
use Getopt::Long;


# Array of table/field hashes.
my @dbpieces = (
   { table => "tng_families", field => "marrplace" },
   { table => "tng_families", field => "divplace" },
   { table => "tng_people", field => "birthplace" },
   { table => "tng_people", field => "altbirthplace" },
   { table => "tng_people", field => "deathplace" },
   { table => "tng_people", field => "burialplace" },
   { table => "tng_events", field => "eventplace" },
   { table => "tng_places", field => "place" },
);

my @states = split( /\s\s+/,
   q(Alabama
   Alaska
   Arizona
   Arkansas
   California
   Colorado
   Connecticut
   Delaware
   District of Columbia
   Florida
   Georgia
   Hawaii
   Idaho
   Illinois
   Indiana
   Iowa
   Kansas
   Kentucky
   Louisiana
   Maine
   Maryland
   Massachusetts
   Michigan
   Minnesota
   Mississippi
   Missouri
   Montana
   Nebraska
   Nevada
   New Hampshire
   New Jersey
   New Mexico
   New York
   North Carolina
   North Dakota
   Ohio
   Oklahoma
   Oregon
   Pennsylvania
   Rhode Island
   South Carolina
   South Dakota
   Tennessee
   Texas
   Utah
   Vermont
   Virginia
   Washington
   West Virginia
   Wisconsin
   Wyoming)
);

# Getopt variables
my ($db_host, $db_name, $db_user, $db_pw, $doupdate);

GetOptions(
   'h|host=s'     => \$db_host,
   'd|database=s' => \$db_name,
   'u|user=s'     => \$db_user,
   'update'       => \$doupdate,
   'p|password=s' => \$db_pw,
);

# Connect to the database using the supplied information.
my $dbh = DBI->connect("dbi:mysql:$db_name:$db_host", "$db_user", "$db_pw", {RaiseError => 1, PrintError => 1}) or die("Cannot connect to the database: " . DBI->errstr);

# Loop through each state
foreach my $state (@states) {
   print "Searching for $state..\n";
   # Then loop through each table/field pair
   foreach my $dbpiece (@dbpieces) {
      my $table = $dbpiece->{'table'};
      my $field = $dbpiece->{'field'};
      print "  in $table > $field: ";
      if ($doupdate ) {
         my $sql = "UPDATE $table SET $field = replace($field, '$state', '$state, USA') WHERE $field REGEXP '$state\$'";
         my $sth = $dbh->prepare( $sql );
         $sth->execute();
         print "(" . $sth->rows . ") rows affected.\n";
      }
      else {
         my $sql = "SELECT * FROM $table WHERE $field REGEXP '$state\$'";
         my $sth = $dbh->prepare( $sql );
         $sth->execute();
         #my @results = $sth->fetchrow_array();
         print "(" . $sth->rows . ") rows found.\n";
      }

   }
}

$dbh->disconnect or die("Cannot disconnect from the database");
