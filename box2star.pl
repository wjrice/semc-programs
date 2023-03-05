#! /usr/bin/perl -w
#
use strict;
my @files = glob("*.box");
foreach my $file (@files) {
   open (IN,$file) or die "cannot read $file\n";
   my $fileout = $file;
   $fileout =~ s/box/star/;
   my $filename = $file;
   $filename =~ s/box/mrc/;
   open (OUT,">$fileout") or die "cannot write $fileout\n";
   print OUT <<eof;

data_

loop_
_rlnCoordinateX #1
_rlnCoordinateY #2
_rlnCoordinateZ #3
_rlnAngleRot #4
_rlnAngleTilt #5
_rlnAnglePsi #6
_rlnMicrographName #7
eof
   while (<IN>) {
      my @data = split(" ",$_);
      print OUT "$data[0] $data[1] $data[2] 0 0 0 $filename\n";
   }
   close (IN);
   close (OUT);
}
 
