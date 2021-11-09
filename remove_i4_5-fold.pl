#! /usr/bin/perl -w
# program to process icosahedral symmetry expanded star file
# comes from Briggs 2020 paper
# processed subregions of an icosahedral virus as C5 by doing symmetry expansion and removing 5-fold duplicates
# main challenge was to work out which symmetry items correspond to this axis
# in i4, 5-fold axis is centred on Z

# wjr 03-10-2021

#i4
my @array= qw(1 2 3 4 5 6 10 12 20 29 38 48  );
#1 2 3 4 5 6 10 12 20 28 29 38 48 
# the #28 array appears to be redundant:
#    there should only be 12 not 13
#    the #28 is a -36 degree rotation, then 180 rotation, and a final in-plane 180 degree rotation
#    3xamination of the removed matrices finds 4 at 0 degree tilt (72,-72,36,-36) and 4 at 180 degree (36,-72,72,0)
#    -36 degree is missing from 180 degree set. All 5 should be removed  

#my $infile='shorter_i4.star';
#my $outfile='shorter_i4_5fold.star';

unless ($#ARGV >0) {die "Usage: remove_i4_5-fold.pl <i4-expanded.star> <output.star>\n";}
my $infile = $ARGV[0];
my $outfile=$ARGV[1];

open (IN,$infile) or die "no read\n";
open (OUT,">$outfile") or die "no write\n";
for (my $i=0; $i<26; $i++) {
   my $line=<IN>;
   print OUT $line;
}

while (not eof) {
   $count++;
   my @alldata=();
   for (my $i=0; $i<60; $i++) {
      my $line=<IN>;
      push @alldata, $line;
   }
   last unless ($#array>0);
   foreach my $value (@array) {
      print OUT $alldata[$value-1];
   }
   if ($count%1000 ==0) {print "count = $count\n";}
}

