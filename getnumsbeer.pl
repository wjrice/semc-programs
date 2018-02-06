#! /usr/bin/perl -w
#
if ($ARGV[0]) {$filein = $ARGV[0];} else {die "usage getnums.pl thicknessfile\n";}
open (IN,$filein) or die "cannot read\n";
while (<IN>) {
   $i++;
   @data=split(" ",$_);
   $thwin = pop (@data);
   pop @data;
   $th = pop (@data);
   if ($th <0 and $th > -2) {$th=0;} #filter out tiny negative values
   if ($thwin <0 and $thwin > -2) {$thwin=0;}

   print "$i $th $thwin\n";
#   if ($th < 30) {print $_;}
}

