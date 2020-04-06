#! /usr/bin/perl -w
#little script to get the coordinates ONLY from a relion 3d refine
#point is to avoid extracting with extraneous CTF information (use it from a prior step)
#also takes the beam tilt and beeam tilt group
# flips the beam tilt in y direction, since relion and appion aligned images are flipped about x axis
# does not flip the y coordinate, since this had already been done. future: perhaps do all in this one script
#hacky
#wjr 06082019
#
#not generalizing
#_rlnCloordX = array pos 0 (#1)
#_rlc_coordY = array pos 1
#_rln_beamTiltX = pos 29
#_rln_beamttiltY= pos 30
#_rlnBeamTiltClass = pos 31 (#32)
my $in='run_data_flipped.star';
my %info;
open (IN,$in) or die "no read!";
mkdir 'temp';
while (<IN>) {
   my @data=split(" ",$_);
   next unless ($#data > 20);
   my $file = $data[3];
   my $xcoord=$data[0];
   my $ycoord = $data[1];
   my $tiltx = $data[29];
   my $tilty = $data[30]* -1;  #FLIP THE Y TILT
   my $class = $data[31];
   @data=split("/",$file); #get rid of path, keep only filename
   $file = $data[$#data];
   @data=($xcoord,$ycoord,$tiltx,$tilty,$class);
   push (@{$info{$file}},\@data);
}
close (IN);
my @keys = sort keys %info;
foreach $file (@keys) {
   my $filename = $file;
   $filename =~ s/\.mrc/_manualpick.star/;
   open (OUT,">temp/$filename") or die "cannot write temp/$filename\n";
   print OUT <<EOF

data_

loop_ 
_rlnCoordinateX #1 
_rlnCoordinateY #2 
_rlnBeamTiltX #3 
_rlnBeamTiltY #4 
_rlnBeamTiltClass #5 
EOF
;
   my @points = @{$info{$file}};
   for my $i (0 .. $#points) {
      print OUT  join("     ",@{$points[$i]}) . "\n";
   }
   close (OUT);
   print "finished $filename\n";
}


