#! /usr/bin/perl -w
#
my $badfile='20feb11f_bad.txt';
my $starfile='goodparticles_BoxNet2_20180602.star';
my $outstar='goodparticles_BoxNet2_20180602_edited.star';

open (IN,$badfile) or die "no read $badfile\n";
while (<IN>) {
   chomp;
   push @badlist,$_;
}
close (IN);

open (IN,$starfile) or die "no read $starfile\n";
open (OUT,">$outstar") or die "no write $outstar\n";
while (<IN>) {
   my @data=split (" ",$_);
   if ($#data <3) {
       print OUT;
   }
   else {
      my $bad=0;
      foreach $file (@badlist) {
         if ($_=~ m/$file/) {
            $bad=1;
            last;
         }
      }
   unless ($bad) {print OUT;}
   }
}
