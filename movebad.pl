#! /usr/bin/perl -w
#
open (IN,'run.err') or die "no read\n";
unless (-e 'Bad') {`mkdir Bad`;}
while (<IN>) {
   next unless (m/(Micrographs.*tif):/);
   my $filename = $1;
   $filename =~ s/\.frames\.tif/_frames.mrc/;
   my $newfile = $filename;
   $newfile =~ s/Micrographs/Bad/;
   print "mv $filename $newfile\n";
   `mv $filename $newfile`;
}

