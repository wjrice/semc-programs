#! /usr/bin/perl -w
#
use strict;
my @dirs = glob("/data/cryoem/cryoemdata/cache/23jun*");
foreach my $dir (@dirs) {
   my @pow=glob("$dir/*pow.jpg");
   if ($#pow < 2) {
      print "no power in $dir\n";
   }
}

