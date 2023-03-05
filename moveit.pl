#! /usr/bin/perl -w
#
open (IN,'imported.log') or die "no read\n";
while (<IN>) {
   chomp;
   s/^\d+_//;  # get rid of extra cryosparc digits at start
   `mv rawdata/$_ imported/.`;
   print "mv rawdata/$_ imported/.\n";;
}
