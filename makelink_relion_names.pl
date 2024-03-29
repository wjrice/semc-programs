#! /usr/bin/perl -w
# script to renme from esn-a-DW files to the name given by relion
# which is esn_frames.mrc
# check first that the file has been cached before renaming
# run directly inside the leginon/session/rawdata folder
# wjr 06-14-23
#

use strict;
my $session;
if (defined $ARGV[0]) {
   $session=$ARGV[0];
}
else {
   print "Enter session: ";
   chomp ($session=<STDIN>);
}

my @files = glob("*-DW.mrc");
foreach my $file (@files) {
   my $newfile = $file;
   $newfile =~ s/esn-a-DW/esn_frames/;
   my $jpgfile = $file;
   $jpgfile =~ s/mrc/jpg/;
   if (-e "/data/cryoem/cryoemdata/cache/$session/$jpgfile") {
      rename  $file, $newfile;
   }
}

