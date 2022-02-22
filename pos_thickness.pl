#! /usr/bin/perl -w
#
# script to query Leginon db and get thickness by grid XY position
# results easily plotted in eg gnuplot using splot
# specify session name, grid name (optional) and output file (optional)
# uses all esn images by default, defaults to screen output
# positions converted to microns, and thickness in nm so scales are good for plotting
#
use DBI;

my $grid_name='';  # no grid specified
my $session_name = '21dec15b';   # default session

if (defined $ARGV[0]) {
   $session_name = $ARGV[0];
}
else {
   die "Usage: thick_pos.pl <session name> <OPTIONAL grid pattern> <OPTIONAL output file>\n";
}

if (defined $ARGV[1]) {
   $grid_name = $ARGV[1];
}

if (defined $ARGV[2]) {
   $outfile = $ARGV[2];
   open (OUT,">$outfile") or die "cannot write to $outfile\n";
}

my $dbh = DBI -> connect('dbi:mysql:database=leginondb;host=10.150.168.11;port=3306;mysql_compression=1','usr_object','NYULMC123');

my $sessionid = $dbh->selectrow_array("select DEF_id from SessionData where name = '$session_name'");
print "session ID is $sessionid\n";
print "grid name selected is $grid_name\n";


my $rows = $dbh->selectall_arrayref("select a.`MRC|Image`, scope.`SUBD|stage position|x`, scope.`SUBD|stage position|y`, scope.`SUBD|image shift|x`, scope.`SUBD|image shift|y`, scope.`SUBD|stage position|z`, t.thickness  from AcquisitionImageData a left join ScopeEMData scope ON (scope.`DEF_id`=a.`REF|ScopeEMData|scope`) left join ObjIceThicknessData t ON a.`DEF_id` = t.`REF|AcquisitionImageData|image` where a.`REF|SessionData|session`= $sessionid  AND `filename` like '%$grid_name%esn'") ;

foreach $row (@$rows) {
   my $xpos = 1e6 * ($row->[1] + $row->[3]);
   my $ypos = 1e6 * ($row->[2] + $row->[4]);
   my $zpos = 1e6 * $row->[5];
   my $thickness = $row->[6];
   my $imagename = $row->[0];
   if (defined $outfile) {
      print OUT "$imagename $xpos $ypos $zpos $thickness\n";
   }
   else {
      print "$imagename $xpos $ypos $zpos $thickness\n";
   }
}



