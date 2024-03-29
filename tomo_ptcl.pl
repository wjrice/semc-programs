#! /usr/bin/perl -w
use strict;
use warnings;
# wjr 01/01/23
# go through s picked particle set from stakcs of 2d images
# to return back to 3d coordinates 
# traces particles through sections

my $debug=0;
my $infile ; # needs to be defined by user
my $radius; # needs to be defined by user
if (defined $ARGV[0]) {
	$infile = $ARGV[0];
}
else {
	print "Enter name of particles star file: ";
	chomp ($infile = <STDIN>);
}
if (defined $ARGV[1]) {
	$radius = int($ARGV[1]/2+0.5);
}
else {
	print "Enter particle diameter in pixels: ";
	my $diameter = <STDIN>;
	$radius = int ($diameter/2 + 0.5);
}
if (defined $ARGV[2]) {
	$debug=1;
}


#read header   -- go to the last loop to take care of relion 2/3.1 issues
my %header;
my $countloop=0;
my $numloops = `grep loop $infile | wc -l`;
open (IN,$infile) or die "cannot read $infile\n";
while ($countloop < $numloops) {
   my $line=<IN>;
   if ($line =~ m/loop/) {
      $countloop++;
   } 
}

my $line = <IN>;
while ( $line =~ m/_rln(\w+)\s\#(\d+)/) {
   my $type=$1;
   my $itemnum=$2;
   $header{$type} = $itemnum -1 ; #array numbers start at 0 while relion starts at 1
   chomp $line; 
#   print "header $line type $type itenmum $itemnum\n";
   $line = <IN>;
}

my @keys = sort keys (%header);

#
my %coordata; #complex record: hash of tomos holding hash of z values holding array of points per zval, each point is 2 dimensional array of (x,y)
my @data = split(" ",$line);
my $micname = $data[$header{'MicrographName'}];
my $xcoord = $data[$header{'CoordinateX'}];
my $ycoord = $data[$header{'CoordinateY'}];
$micname =~ s/(\d+)-(\d+)\.mrc$/.mrc/;
my $zval = ($1 + $2)/2;
#print "$micname $zval\n";
push @{$coordata{$micname}{$zval}} , [$xcoord, $ycoord];
@keys = sort keys %coordata;
foreach my $key (@keys) {
    my $ref = \%coordata;
    #print "$coordata{$key} $ref \n";
#    my @keys2 = sort keys %{$coordata{$key}};
#    print "@keys2\n";
    #print "inner\n";
    # foreach my $key2 (@keys2) {
    #   print "$key $key2 $coordata{$key}{$key2}[0][0] $coordata{$key}{$key2}[0][1] \n";
    #}
}
my $i=1;
while (<IN>) {
   $i++;
   @data = split(" ",$_);
   $micname = $data[$header{'MicrographName'}];
   $xcoord = $data[$header{'CoordinateX'}];
   $ycoord = $data[$header{'CoordinateY'}];
   $micname =~ s/(\d+)-(\d+)\.mrc$/.mrc/;
   $zval = ($1 + $2)/2;
   #   print "line=$i $micname $xcoord $ycoord $zval\n";
   push @{$coordata{$micname}{$zval}} , [$xcoord, $ycoord];
}

my @tomos = sort keys %coordata;
my (@goodpointsx,@goodpointsy,@goodpointsz,@zvals);
my ($sumx,$sumy,$sumz,$nextlevel);
foreach my $tomo (@tomos) {
	print "working on file $tomo\n";
	my $fileout = $tomo;
	$fileout =~ s/\.mrc/_coords.star/;
	@zvals = sort {$a <=> $b} keys %{$coordata{$tomo}};
	open (OUT,">$fileout") or die "failed to write $fileout\n";  # all points
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
_rlnAutoPickFigureOfMerit #8
eof
	if ($debug){
		open (OUT2,">$fileout.all") or die "failed to write $fileout.tst\n"; # edited points
		print OUT2 <<eof;  
data_

loop_
_rlnCoordinateX #1
_rlnCoordinateY #2
_rlnCoordinateZ #3
_rlnMicrographName #4
eof
		# next block writes all data, only of debug flag is set
		foreach my $zval (@zvals) {
			my $length = $#{$coordata{$tomo}{$zval}};
			#print "zval $zval with length $length\n";
       			foreach my $item (@{$coordata{$tomo}{$zval}}) {
	       			my $x = @{$item}[0];
	       			my $y = @{$item}[1];
       	       			print OUT2 "$x $y  $zval $tomo \n";
    			}
    		}
		close (OUT2);
	}
	for (my $i=0; $i<$#zvals; $i++) {  # loop through all of the zvals apart from bottom one
		my $length = $#{$coordata{$tomo}{$zvals[$i]}};
		foreach my $point (@{$coordata{$tomo}{$zvals[$i]}}) { #iterate through all current points
			(@goodpointsx,@goodpointsy,@goodpointsz) = ((),(),());
	       		($sumx,$sumy,$sumz) = (0,0,0);
	       		my $x = @{$point}[0];
	       		my $y = @{$point}[1];
	       		push @goodpointsx,$x;
	       		push @goodpointsy,$y;
	       		push @goodpointsz,$zvals[$i];
	       		my $down1=0; # counter for where to remove found points
	       		my $length2 = $#{$coordata{$tomo}{$zvals[$i+1]}};
	       		my $found = 1; #reset next level founbd flag
			$nextlevel = $i +1 ; 
			while ($found and $nextlevel <= $#zvals) {
	       			$found = drilldown($x,$y,$coordata{$tomo}{$zvals[$nextlevel]}); #iterate through next level
		  		$nextlevel++;
	       		}
			for (my $j=0; $j<=$#goodpointsx; $j++) {
				$sumx += $goodpointsx[$j];
				$sumy += $goodpointsy[$j];
				$sumz += $goodpointsz[$j];
	       		}
			$sumx /= ($#goodpointsx + 1);
	       		$sumy /= ($#goodpointsy + 1);
	       		$sumz /= ($#goodpointsz + 1);
			if ($#goodpointsx > 0) { # only write of it corsses 2 sections at least
	       			printf OUT "%.2f %.2f %.2f %.2f %.2f %.2f %s %0.2f\n", ($sumx,$sumy,$sumz,0,0,0,$tomo,($#goodpointsx+1)/10) ; # perhaps add conditional to write only if 2+ points foind
			}
        	}
	} 
	              

    	close (OUT);
	print "Wrote $fileout\n";
}

sub distance {
# calculates distance between 2 points (x1,y1) and (x2,y2), sent in that order
	return sqrt( ($_[0] - $_[2])**2 + ($_[1] - $_[3])**2)
}
sub drilldown {
# subroutine to find matching coordinates on next lower level
# modifies array of next level: removes point found
# appends any founbd point x,y,z coords to goodpoints for later averaging
	my $x1=$_[0];
	my $y1=$_[1];
	my $arrayref = $_[2];
	my $found = 0;
	my $pointnum = 0;
	foreach my $point2 (@{$arrayref}) { #iterate through next level
		my $x2 = @{$point2}[0];
		my $y2 = @{$point2}[1];
		my $dist = distance($x1,$y1,$x2,$y2);
		if ($dist < $radius) {
			push @goodpointsx,$x2;
			push @goodpointsy,$y2;
			push @goodpointsz,$zvals[$nextlevel];
			splice(@{$arrayref},$pointnum,1); #remove point from list
			$found =1; # flag that next level found something, so ok to keep looking one more level down
			last; #assume no x-y overlap so only one point max 
		}
		$pointnum++;
	}
	return $found;
}
 
