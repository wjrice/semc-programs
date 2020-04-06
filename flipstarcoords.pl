#! /usr/bin/perl -w
# program to flip the coordinates about x axis
# needed to convert from Appion motioncorr to Relion motioncorr coordinates
# also corrects the ctf angle
# use: flipstarcoords.pl infile
# output: input_flipped.star
# wjr 04/28/2019
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
my $ysize = 3837; ##or 3838?
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
      }
   }
   else {
      $data[$starval{'_rlnCoordinateY'}] = sprintf ("%.6f",$ysize - $data[$starval{'_rlnCoordinateY'}]);
      $data[$starval{'_rlnOriginY'}] *= -1;
      $data[$starval{'_rlnDefocusAngle'}] *= -1; ##angle in range -180 to 180
      $outstring = join ("    ",@data);
      print OUT "$outstring\n";
   }
}


