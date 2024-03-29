#! /usr/bin/perl -w
# program to flip the coordinates about x axis
# needed to convert from Appion motioncorr to Relion motioncorr coordinates
# also corrects the ctf angle
# use: flipstarcoords.pl infile
# output: input_flipped.star
# wjr 04/28/2019
# 01-12-24 fixed bug where it inverts the x coordinate if _rlnOriginY or _rlnDefocusAngle does not exist in header
#
my $instar = 'particles.star';
if ($ARGV[0]) {
   $instar = $ARGV[0];
}
else {
   print "Enter input star file, default $instar: ";
   chomp (my $line = <STDIN>);
   if ($line) {$instar = $line;}
}
my $outstar = $instar;
$outstar =~ s/\.star/_flipped.star/;
my @keys;
my $ysize = 4091; ##or 3838?
open (IN, $instar) or die "cannt read $instar\n";
open (OUT, ">$outstar") or die "Can't write $outstar\n";
while (<IN>) {
   my @data = split(" ",$_);
   if ($#data<2 or $_ =~ m/^#/) {
      print OUT ;
      if ($_ =~ m/\#\d+/) {
         $starval{$data[0]} = $data[1];
         $starval{$data[0]} =~ s/#//;
         $starval{$data[0]} -= 1;
         print "$data[0] $starval{$data[0]} \n";
         push @keys, $data[0];
      }
   }
   else {
      $data[$starval{'_rlnCoordinateY'}] = sprintf ("%.6f",$ysize - $data[$starval{'_rlnCoordinateY'}]);
      if ( grep( /^_rlnOriginY$/, @keys ) ) {
	      $data[$starval{'_rlnOriginY'}] *= -1;
      }
      if ( grep( /^_rlnDefocusAngle$/, @keys ) ) {
         $data[$starval{'_rlnDefocusAngle'}] *= -1; ##angle in range -180 to 180
      }
      $outstring = join ("    ",@data);
      print OUT "$outstring\n";
   }
}


