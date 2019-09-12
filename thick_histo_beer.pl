#! /usr/bin/perl -w
#
#gets the thickness values and outputs a histogram
my $bin=10 ; #binning width
my $max=50 ; #max number of bins to consider
my $outfile = "values.txt";
my $center = $bin/2;
my @histo;
for ($i=0; $i<=50; $i++) {$histo[$i]=0;}
unless ($ARGV[0]) {die "usage: thick_histo.pl [inputfile]\n";}
my $filein = $ARGV[0];
open (IN,$filein) or die "cannot read $filein\n";
open (OUT,">$outfile") or die "cannot write to $outfile\n";
while (<IN>) {
   @data=split(" ",$_);
   next unless ($#data>2);
   $val=pop @data;
   print OUT "$val\n";
   if ($val <0) {$bad++;$histo[0]++;}
   else {
      for ($i=0; $i<$max; $i++) {
         if (($val >= $i*$bin) and $val < ($i+1) *$bin) {
            $histo[$i]++;
         }
      }
   }
}
close (IN);
close (OUT);
for ($i=0; $i <=$max; $i++) {
   print $i*$bin+$center . "  $histo[$i] \n";
}
print "negative values: $bad\n";

