#! /usr/bin/perl -w
use Math::Trig;

my $vangle = 38 ; #default viewing angle
my $zsec = 20; #default z-slice width in nm

print "Enter name of xg file: ";
chomp ($xgfile=<STDIN>);
die "cannot fine file $xgfile\n" unless (-e $xgfile);
$line = `wc -l $xgfile`;
@data=split(" ", $line);
$numsec = $data[0];
print "Enter viewing angle (default $vangle): ";
chomp ($line=<STDIN>);
my $pi = 4*atan(1);
$vangle = $vangle * $pi / 180; #convert to radians
if ($line) {$vangle = $line;}
print "Enter z section width in nm (default $zsec): ";
chomp ($line=<STDIN>);
if ($line) {$zsec = $line;}
print "Enter pixel size in nm (x-pixel): ";
chomp ($apix = <STDIN>);

$drift_per_sec = $zsec * sin($vangle) / $apix ; # in PIXELS
$totaldrift = $drift_per_sec * $numsec;
$add_drift = $totaldrift/2;
$addpix = int ($totaldrift+0.5);
print "Need to add $addpix pixels to y-size to account for drift\n";
$sum1 = $addpix+1768;
$sum2 = $sum1 + 2* 1768;

print "$addpix plus 1768 = $sum1 \n";
print "$addpix plus 3536 = $sum2\n";

open (IN, $xgfile) or die "cannot read $xgfile\n";
$xgout = $xgfile . "skew";
open (OUT,">$xgout") or die "cannot write $xgout\n";
$nline = 0;
while (<IN>) {
   @data=split;
   last if ($#data<5);
   $dely = pop(@data);
   $dely = $dely + $add_drift - $nline * $drift_per_sec; 
   push @data,$dely;
   printf OUT ("  %.6f  %.6f  %.6f  %.6f     %.3f     %.3f\n", $data[0],$data[1],$data[2],$data[3],$data[4],$data[5]);
   $nline++;
} 

print "finished writing skewed xg file $xgout\n";
