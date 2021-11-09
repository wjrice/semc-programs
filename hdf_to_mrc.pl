#! /usr/bin/perl -w
#
my @files=glob("*bin4.hdf");
foreach my $file (@files) {
   my $fileout=$file;
   $fileout =~ s/hdf/mrc/;
   `e2proc3d.py $file $fileout`;
   print "created $fileout\n";
}

