#! /usr/bin/perl -w
#script to calculate a moving average of the relion bfactor file
#does a 3-point moving average, with the forst 2 points and the final point unchanged
#only does it on column 2 (bfactors), intercepts unchanged
#

$move=3 ; 
print "Enter file: ";
chomp ($file=<STDIN>);
open (IN,$file) or die "cannot read $file\n";
$fileout = $file . '_moving';
print "writing to $fileout\n";
open (OUT,">$fileout") or die "cannot write $fileout\n";
print "Moving average of 3 or 5 (default 3): ";
chomp ($line=<STDIN>);
if ($line == 5) {$move=5;}

while ($line=<IN>) {
   @data=split (" ",$line);
   if ($#data <2) {
      print OUT $line;
   }
   else {
   push @col1,$data[1];
   push @col2,$data[2];
   }
}
for ($i=0; $i<2; $i++) {$newcol1[$i] = $col1[$i];}
if ($move == 3) {
   for ($i=2; $i<=($#col1-1); $i++) {
      $newcol1[$i] = ($col1[$i-1] + $col1[$i] + $col1[$i+1])/3;
   }
   $newcol1[$#col1] = $col1[$#col1];
}
else {
   for ($i=2; $i<=($#col1-2); $i++) {
      $newcol1[$i] = ($col1[$i-2] + $col1[$i-1] + $col1[$i] + $col1[$i+1] + $col1[$i+2] )/5;
   }
   $newcol1[$#col1-1] = ($col1[$#col1-4] + $col1[$#col1-3]+ $col1[$#col1-2] +$col1[$#col1-1] +$col1[$#col1]) /5;
   $newcol1[$#col1] = ($col1[$#col1-3]+ $col1[$#col1-2] +$col1[$#col1-1] +$col1[$#col1]) /4;
}

for ($i=0; $i <= $#col1; $i++) {
   print OUT $i+1 . " $newcol1[$i] $col2[$i]\n";
}


