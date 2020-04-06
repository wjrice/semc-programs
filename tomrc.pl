#! /usr/bin/perl -w
my @files=glob("*.tif");
foreach $file (@files) {
   $fileout=$file;
   $fileout =~ s/tif/mrc/;
   `e2proc2d.py $file $fileout --outmode=int8`;
   print "created $fileout\n";
}

