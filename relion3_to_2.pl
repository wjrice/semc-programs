#! /usr/bin/perl 
# small script to convert from relion 3.1+ to relion 3.0 or relion 2
# usage: relion3_to_2.pl <input star>
# outputs input_rln2.star
#
# handles all optics groups
# wjr 072321
#
use warnings;
use strict;
my ($filein,$fileout,%opticsdata,@data,@extra_rln,$save,$pix_index,$x_index,$y_index,$opticsname_index,$optics_index,$dimension_index,$first,$opticsgroup);

if (defined $ARGV[0]) {
   $filein = shift @ARGV;
   $fileout = $filein;
   $fileout =~ s/\.star/_rln2.star/;
}
else {
   die "Usage: relion3_to_2.pl <input relion3 file>\n"
}

print "converting $filein to $fileout in relion 2/3.0 format\n";

open (IN,$filein) or die "no read $filein\n";
while (<IN>) {
   if (m/loop_/) {last;}
}
$dimension_index = -1;

while (<IN>) {
   unless (m/_rln/) {
      @data = split(" ",$_);
      last;
   }
   s/rlnImagePixelSize/rlnPixelSize/ ;
   my @data = split(" ",$_);
   push @extra_rln,$data[0];
   if (m/rlnPixelSize/) {
      $pix_index = $#extra_rln;
   }
   if (m/rlnOpticsGroup\s/) {
      $optics_index = $#extra_rln;
   }
   if (m/rlnOpticsGroupName/) {
      $opticsname_index = $#extra_rln;
   }
   if (m/rlnImageDimensionality/) {
      $dimension_index = $#extra_rln;
   }
}
print "optics index = $optics_index \t\t opticsname indsex = $opticsname_index\n";
# remove the optics group data
if ($opticsname_index > $optics_index) {
   splice(@extra_rln,$opticsname_index,1);
   splice(@data,$opticsname_index,1);
   splice(@extra_rln,$optics_index,1);
   $opticsgroup = splice(@data,$optics_index,1);
   $first=1; print "first\n";
}
else {
   splice(@extra_rln,$optics_index,1);
   $opticsgroup = splice(@data,$optics_index,1);
   splice(@extra_rln,$opticsname_index,1);
   splice(@data,$opticsname_index,1);
}
if ($dimension_index > $opticsname_index) {$dimension_index -= 1; print "subtracted dim index\n";}
if ($dimension_index > $optics_index) {$dimension_index -= 1; print "subtracted dim index\n";}
if ($dimension_index >=0) {
   splice(@extra_rln,$dimension_index,1);
   splice(@data,$dimension_index,1);
   if ($pix_index > $dimension_index) {$pix_index -= 1; print "subtracted pix index\n";}
}

$opticsdata{$opticsgroup} = [ @data ] ;
if ($pix_index > $opticsname_index) {$pix_index -= 1; print "subtracted pix index\n";}
if ($pix_index > $optics_index) {$pix_index -= 1; print "subtracted pix index\n";}

print "found optics group $opticsgroup\n";
print "@{$opticsdata{$opticsgroup}}\n" ;

open (OUT,">$fileout") or die "cannot write $fileout\n";
print OUT "# converted from relion 3.1\n";
print OUT "# using all optics groups!";
print OUT "\ndata_\n\n";
while (<IN>) {
   if (m/loop_/) {
      print OUT;
      last;
   }
   else {
      my @data=split(" ",$_);
      if ($#data > 3) {
         if ($first > 0 ) {
            splice(@data,$opticsname_index,1);
            $opticsgroup = splice(@data,$optics_index,1);
            print "found opticsgroup $opticsgroup in OPTICSDATA";
            print "@{$opticsdata{$opticsgroup}}\n" ;

         }
         else {
            $opticsgroup = splice(@data,$optics_index,1);
            print "found opticsgroup $opticsgroup in OPTICSDATA"; 
            print "@{$opticsdata{$opticsgroup}}\n" ;
            splice(@data,$opticsname_index,1);
         }
         if ($dimension_index >=0) {
            splice(@data,$dimension_index,1);
         }
         $opticsdata{$opticsgroup} = [ @data ];
      }
   }      
}

my $datanum=0;
while (<IN>) {
   $datanum++;
   unless (m/_rln/) {
      $save = $_;  # save the first data
      chomp $save;
      last;
   }
   if (m/_rlnOriginXAngst/) {$x_index = $datanum-1;}
   if (m/_rlnOriginYAngst/) {$y_index = $datanum-1;}
   $_ =~ s/Angst//;
   if (m/rlnOpticsGroup/) {
      $optics_index = $datanum - 1; 
      $datanum -= 1;
   }
   else {
      my @data=split(" ",$_);
      print OUT "$data[0] #" . $datanum . "\n";
   }
}

for (my $i=0; $i<=$#extra_rln; $i++) {
   print OUT "$extra_rln[$i] #" . $datanum . "\n";
   $datanum++;
}

if ($x_index > $optics_index) {$x_index -= 1;}
if ($y_index > $optics_index) {$y_index -= 1;}

while (<IN>) {
   my @old_data = split(" ",$_);
   if ($#old_data < 5) { # do the saved one last
      @old_data = split(" ",$save);
   }
   $opticsgroup = splice(@old_data,$optics_index,1);
   $old_data[$x_index] /= $data[$pix_index] ;
   $old_data[$y_index] /= $data[$pix_index] ;
   for (my $i=0; $i <= $#old_data; $i++) {
      print OUT "$old_data[$i] ";
   }
   for (my $i=0; $i<=$#data; $i++) {
      print OUT "$opticsdata{$opticsgroup}[$i] ";
   }
   print OUT "\n";
} 
