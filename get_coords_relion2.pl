#! /usr/bin/perl -w
#
my $filein='cryosparc_P2_J2151_007_particles.star';
my $fileout = $filein;
$fileout =~ s/.star/_coords.star/;
open (IN,$filein) or die "cannot read $filein\n";
open (OUT,">$fileout") or die "cannot erite $fileout\n";
print OUT <<eof; 

data_images

loop_
_rlnMicrographName #1 
_rlnCoordinateX #2 
_rlnCoordinateY #3 
eof
while (<IN>) {
   next unless (m/mrc/);
   my @data = split (" ",$_);
   my ($name,$x,$y) = ($data[1],$data[2],$data[3]);
   @data = split(/\//,$name);
   $name = pop @data;
   $name =~ s/^\d+_//;
   print OUT "$name $x $y\n";
}


