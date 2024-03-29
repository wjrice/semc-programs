#! /usr/bin/perl -w
#
# script to query Leginon db and get a count of the number of images per day on a given microscope
# microscope is krios_k3 or arctica_k3
# groups by daynumber so do not do for periods longer thna 1 year
# results easily plotted in eg gnuplot using plot or imported into excel
# specify output filename. Optional inputs are start date, end date, and microscope
# looks for esn and enn images only, no filtering as to minimum number of images
# 
# wjr-9-25-2023
use DBI;

my $start_date = '2023-01-01';
my $end_date = '2023-12-31';
my $hostname = 'krios-k3';

if (defined $ARGV[0]) {
   $outfile = $ARGV[0];
   open (OUT,">$outfile") or die "cannot write to $outfile\n";
}
else {
   die "Usage: $0 <output file> <optional start date default $start_date> <optional end date default $end_date> <optional hostname default $hostname>\n";
}

if (defined $ARGV[1]) {
   $start_date = $ARGV[1];
}

if (defined $ARGV[2]) {
   $end_date = $ARGV[2];
}
if (defined $ARGV[3]) {
   $hostname = $ARGV[3];
}

my $dbh = DBI -> connect('dbi:mysql:database=leginondb;host=10.150.168.11;port=3306;mysql_compression=1','usr_object','NYULMC123');

#my $sessionid = $dbh->selectrow_array("select DEF_id from SessionData where name = '$session_name'");
#print "session ID is $sessionid\n";
#print "grid name selected is $grid_name\n";


my $rows = $dbh->selectall_arrayref("SELECT a.`REF|SessionData|session` , a.`DEF_timestamp` , d.`name`,c.`hostname`, DAYOFYEAR(a.`DEF_timestamp`) as `day`,COUNT(*)  FROM  `AcquisitionImageData` a INNER JOIN  `CameraEMData` b ON b.DEF_id = a.`REF|CameraEMData|camera`  INNER JOIN  `InstrumentData` c ON c.DEF_id = b.`REF|InstrumentData|ccdcamera`  INNER JOIN  `PresetData` d ON d.DEF_id = a.`REF|PresetData|preset` where (d.`name` =  'enn' OR d.`name` = 'esn') and (a.DEF_timestamp between '$start_date 00:00:00' and '$end_date 23:59:59') and c.`hostname` = '$hostname' GROUP BY `day`;");

foreach $row (@$rows) {
   if (defined $outfile) {
      print OUT "$row->[4] $row->[5] $row->[3] \n";
   }
   else {
      print "$row->[4] $row->[5] $row->[3] \n";
   }
}



