#! /usr/bin/perl -w
use strict;
# purpose: to add back original coordinates and micrograph name to the Relion data file
# issue is that M needs this information, and it was somehow lost in translation from Warp--> cryosaprc-->relion
# input data is the good particles.star file by warp
# and also the run_data.star file from Relion
#
# output is a refined run_data.star file which has the needed header information
#
# Also works for exported cryosparc files, where the original imprt was not attached to a micrograph set
#my $in1 = '../set1/goodparticles_BoxNet2_20180602.star';
#my $in2 = '../set2/goodparticles_BoxNet2_20180602.star';

unless ($#ARGV >1) {die "Usage: addback.pl <warpfile.star> <converted_cpsarcfile.star> <output_csparcfile.star>\n";}
my $in1 = $ARGV[0];
my $runfile=$ARGV[1];
my $outfile=$ARGV[2];

my %coordinate_x;
my %coordinate_y;
my %micrographname;
my ($imnamecol,$micnamecol,$xcol,$ycol);

open (IN,$in1) or die "no read\n";
while (<IN>) {
   my @data=split(" ",$_);
   if ($#data<4) {
      if (m/_rlnCoordinateX/) {$xcol = fixnum(pop @data);}
      if (m/_rlnCoordinateY/) {$ycol = fixnum(pop @data);}
      if (m/_rlnMicrographName/) {$micnamecol = fixnum(pop @data);}
      if (m/_rlnImageName/) {$imnamecol = fixnum(pop @data);}
   }
   else {
    $coordinate_x{$data[$imnamecol]} = $data[$xcol];
    $coordinate_y{$data[$imnamecol]} = $data[$ycol];
    $micrographname{$data[$imnamecol]} = $data[$micnamecol];
   }
}
close (IN);

#open (IN,$in2) or die "no read\n";
#while (<IN>) {
#   my @data=split(" ",$_);
#   next unless ($#data>4);
#    $coordinate_x{$data[$imnamecol]} = $data[$xcol];
#    $coordinate_y{$data[$imnamecol]} = $data[$ycol];
#    $micrographname{$data[$imnamecol]} = $data[$micnamecol];
#}

close (IN);

print "xcol=$xcol, ycol=$ycol, namecol=$imnamecol\n";
#my @keys = sort keys(%coordinate_x);
#for (my $i=0; $i<10; $i++) {print "$keys[$i]\n";}

open (IN,$runfile) or die "cannot read $runfile\n";
open (OUT,">$outfile") or die "cannot write $outfile\n";

my $lastnum=1;
while (<IN>) {
   #s/Particles/particles/;
   #s/imported\/J\d+/particles/;
   s/J\d+\/imported/particles/;
   chomp;
   my @data=split(" ",$_);
   #s/particles/Particles/;
   if ($#data<4) {
      if (m/_rlnImageName/) {$imnamecol = fixnum(pop @data);}
      if (m/_rln/) {$lastnum++;}
      print OUT;
      print OUT "\n";
   }
   else {
      if ($lastnum>0) {
         print OUT "_rlnCoordinateX #$lastnum\n";
         $lastnum++;
         print OUT "_rlnCoordinateY #$lastnum\n";
         $lastnum++;
         print OUT "_rlnMicrographName #$lastnum\n";
         $lastnum=-1;
      }
      my $imname=$data[$imnamecol];
      $imname = "0" . $imname;
      #
      unless (defined($coordinate_x{$imname})) {
         $imname = "0" . $imname;
         print "fixing $imname\n";
      }
      unless (defined($coordinate_x{$imname})) {
         $imname =~ s/^..//;
         print "still broken $imname\n";
      }
      my $newdata=join(" ",($coordinate_x{$imname},$coordinate_y{$imname},$micrographname{$imname}));
      print OUT "$_ $newdata\n";
   }
}

         



sub fixnum  {
   my $num =$_[0];
   $num =~ s/#//;
   $num-= 1;
   return $num;
}



   
