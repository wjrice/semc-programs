#! /usr/bin/perl
#
# script to parse all mdoc files in current directory to determine thickness at all tilt angles 
# uses this to determine tilt angle at which thickness is minimum
# wjr 01-12-2022
#
use strict;
use warnings;
my $ref_intensity = 15 ; 
my $als = 322;
my @files = glob("*.mdoc");

my $pi = atan2(1,1)*4;
my $avg_ang = 0;
foreach my $file (@files) {
   my $fileout = $file . 'tilt';
   my ($dose,@thickness,@angle, @calc_angle);
   open (OUT,">$fileout") or die "cannot write $fileout\n";
   open (IN,$file) or die "cannot read $file\n";
   my $zvalue;

   while (<IN>) {
      if (m/ZValue = (\d+)/) {
         $zvalue = $1;
      }
      if (m/DoseRate\s+=\s+(\d+\.\d+)/) {
         $dose = $1;
         $thickness[$zvalue] = log($ref_intensity/$dose) * $als;
      }
      if (m/TiltAngle = (-?\d+\.\d+)/) {
         $angle[$zvalue] = $1;
      }
   }
   close (IN);
   my $min=1e6;
   my $min_index;
   for (my $i=0; $i <= $#thickness; $i++) {
      if ($thickness[$i] < $min) {
         $min=$thickness[$i];
         $min_index=$i;
      }
   }
   my $angle_offset = $angle[$min_index];
   $avg_ang += $angle_offset;
   foreach my $angle (@angle) {
      $angle -= $angle_offset;
   }
   foreach my $thick (@thickness) {
      my $ang = acos($min/$thick) * 180 / $pi;
      push @calc_angle,$ang;
   }
   $min = int($min);
   print "file $file min thickness is $min nm at angle $angle_offset\n";
   for (my $i=0; $i <= $#angle; $i++)  {
      if ($angle[$i] < 0) {$calc_angle[$i] *= -1;}
      my $diff = $angle[$i] - $calc_angle[$i];
      print OUT "$angle[$i] $calc_angle[$i] $diff $thickness[$i]\n";
   }
   close OUT;
}
$avg_ang /= ($#files +1);
print "average offset is $avg_ang\n";

sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }

