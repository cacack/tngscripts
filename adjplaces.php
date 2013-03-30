<html>
<head></head>
<body>
<?php
include( "tng_begin.php" );

#ini_set('display_errors',1);
#error_reporting(E_ALL);

$dbpieces = array(
   array( table => "tng_families", field => "marrplace" ),
   array( table => "tng_families", field => "divplace" ),
   array( table => "tng_people", field => "birthplace" ),
   array( table => "tng_people", field => "altbirthplace" ),
   array( table => "tng_people", field => "deathplace" ),
   array( table => "tng_people", field => "burialplace" ),
   array( table => "tng_events", field => "eventplace" ),
   array( table => "tng_places", field => "place" ),
);

$states = array(
   "Alabama",
   "Alaska",
   "Arizona",
   "Arkansas",
   "California",
   "Colorado",
   "Connecticut",
   "Delaware",
   "District of Columbia",
   "Florida",
   "Georgia",
   "Hawaii",
   "Idaho",
   "Illinois",
   "Indiana",
   "Iowa",
   "Kansas",
   "Kentucky",
   "Louisiana",
   "Maine",
   "Maryland",
   "Massachusetts",
   "Michigan",
   "Minnesota",
   "Mississippi",
   "Missouri",
   "Montana",
   "Nebraska",
   "Nevada",
   "New Hampshire",
   "New Jersey",
   "New Mexico",
   "New York",
   "North Carolina",
   "North Dakota",
   "Ohio",
   "Oklahoma",
   "Oregon",
   "Pennsylvania",
   "Rhode Island",
   "South Carolina",
   "South Dakota",
   "Tennessee",
   "Texas",
   "Utah",
   "Vermont",
   "Virginia",
   "Washington",
   "West Virginia",
   "Wisconsin",
   "Wyoming",
);

foreach ($states as $state) {
   # What we are searching for.  Note the SQL statement anchors the search to
   # the end of the line. Adjust that too if need be.
   $searchstr = "$state";
   # What we replace it with
   $replacestr = "$state, USA";
   echo "<p>Searching for '$searchstr\$'...<br />\n";
   foreach ($dbpieces as $dbpiece) {
      $table = $dbpiece['table'];
      $field = $dbpiece['field'];
      echo "  $table > $field = ";
      # If the script is passed 'update=1', i.e. adjplace.php?update=1.
      if ($_GET['update']) {
         # The regex '$' only matches at the end of the line.
         $sql = "UPDATE $table SET $field = replace($field, '$searchstr', '$replacestr') WHERE $field REGEXP '$searchstr\$'";
         $result = mysql_query( $sql ) or die ( $text['cannotexecutequery'] . ": $sql" );
         $num = mysql_affected_rows( $result );
         echo "$num rows updated.<br />\n";
      }
      # Otherwise just query the database.
      else {
         $sql = "SELECT * FROM $table WHERE $field REGEXP '$searchstr\$'";
         $result = mysql_query( $sql ) or die ( $text['cannotexecutequery'] . ": $sql" );
         $num = mysql_num_rows( $result );
         echo "$num rows found.<br />\n";
         # If the script is passed 'details=1', print the place field for each record.
         if ($_GET['details']) {
            while ($row = mysql_fetch_assoc($result)) {
               echo "    {$row[$field]}<br />";
            }
         }
      }
   }
   echo "</p>\n";
}

?>
</body>
</html>
