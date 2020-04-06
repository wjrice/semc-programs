#! /usr/bin/perl -w
# script to make a Relion selection setup from WARP particle picks 
# Assumes that micrographs directory already exists, with all micrograph files there
# Outputs to Warppicks direcory, with star formatted coordinate files
# output WarpCtf/warpctfdata.star, which can be used for extraction as it has the relevant Warp-determined CTF info	

# wjr 08-30-19
# add ctf directory for full setup 8-31-19
# does global average of per-particle CTFdata from Warp to calculate overall micrograph CTF values
# assumes that Warp star file has following header

#	loop_
#	_rlnCoordinateX #1
#	_rlnCoordinateY #2
#	_rlnMagnification #3
#	_rlnDetectorPixelSize #4
#	_rlnVoltage #5
#	_rlnSphericalAberration #6
#	_rlnAmplitudeContrast #7
#	_rlnPhaseShift #8
#	_rlnDefocusU #9
#	_rlnDefocusV #10
#	_rlnDefocusAngle #11
#	_rlnCtfMaxResolution #12
#	_rlnImageName #13
#	_rlnMicrographName #14



print "star files:\n";
my @files = glob ("*.star");
foreach my $file (@files) {print "$file\n";}
print "Enter current warp star file (default $files[0]): ";
chomp ($starfile = <STDIN>);
unless ($starfile) {$starfile = $files[0];} 

my $pickdir = 'Warppick';
my $micdir = 'micrographs';
my $ctfdir = 'WarpCtf';
my %stardata;
my %ctfdata;
unless (-e $pickdir) {`mkdir -p $pickdir/$micdir`;}
print "Enter name of micrographs directory (default $micdir): ";
chomp ($line = <STDIN>);
if ($line) {$micdir=$line;}

open (IN,$starfile) or die "cannot read $starfile\n";
while (<IN>) {
   if ($_ =~ m/rlnMicrographName/) {
      last;
   }
}
while (<IN>) {
   chomp $_;
   my @data = split(" ",$_);
   my $filename = pop @data;
   my @coords=(shift @data,shift @data);
   push (@{$stardata{$filename}},\@coords);
   pop @data; #don't need particle stack
   if (defined $ctfdata{$filename}) {
      $data[6] += ${$ctfdata{$filename}}[6] ; 
      $data[7] += ${$ctfdata{$filename}}[7] ; 
      push @data, ${$ctfdata{$filename}}[10] +1;
      $ctfdata{$filename} = \@data; 
   }
   else {
      push @data,1;  # only one existing ctf file, so list number of entries as 1
      $ctfdata{$filename} = \@data; 
   }
}
close (IN);

#

my @keys = sort keys %stardata;
unless (-e $ctfdir) {mkdir $ctfdir;}
open (CTFOUT,">$ctfdir/warpctfdata.star") or die "cannot write $ctfdir/warpctfdata.star\n";
print CTFOUT <<EOF

data_

loop_
_rlnMicrographName #1
_rlnMagnification #2
_rlnDetectorPixelSize #3
_rlnVoltage #4
_rlnSphericalAberration #5
_rlnAmplitudeContrast #6
_rlnPhaseShift #7
_rlnDefocusU #8
_rlnDefocusV #9
_rlnDefocusAngle #10
_rlnCtfMaxResolution #11
EOF
;
my $totalparticles = 0;
foreach $file (@keys) {
   my $filename = $file;
   $filename =~ s/\.mrc/_manualpick.star/;
   $filename = $micdir . '/' . $filename;
   open (OUT,">$pickdir/$filename") or die "cannot write $pickdir/$filename\n";
   print OUT <<EOF

data_

loop_ 
_rlnCoordinateX #1 
_rlnCoordinateY #2 
EOF
;
   my @points = @{$stardata{$file}};
   for my $i (0 .. $#points) {
      print OUT  join("     ",@{$points[$i]}) . "\n";
   }
   close (OUT);
   my $num_particles = pop @{$ctfdata{$file}};
   ${$ctfdata{$file}}[6] /= $num_particles; 
   ${$ctfdata{$file}}[7] /= $num_particles; 
   print CTFOUT "$micdir/$file   " . join("     ",@{$ctfdata{$file}}) . "\n"; 
   print "finished $filename with $num_particles particles\n";
   $totalparticles += $num_particles;
}
close CTFOUT;
# final setup of Relion directory for extraction
open (OUT,">$pickdir/coords_suffix_manualpick.star") or die "cannot write $pickdir/coords_suffix_manualpick.star\n";
print OUT "micrographs.star\n";
close OUT;
open (OUT,">$pickdir/micrographs.star") or die "cannot write $pickdir/micrographs.star\n";
print OUT <<EOF
data_
loop_
_rlnMicrographName
EOF
;
close (OUT);
`ls $micdir/*mrc >> $pickdir/micrographs.star`;
print "finished writing star files for $totalparticles particles\n";
