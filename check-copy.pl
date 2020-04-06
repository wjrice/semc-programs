#! /usr/bin/perl -w
#
chdir "rawdata";
my @files=glob("*.tif");
chdir "../";
open (OUT,">notcopied.txt") or die "no write\n";
foreach $file (@files) {
   unless (-e "/run/media/ricew01/meyerson2/20jan16a/frames/$file") {
      $i++;
      print OUT "$file\n";
   }
}
print "$i files were not copied\n";


