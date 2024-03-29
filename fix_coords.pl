#! /usr/bin/perl -w
my $in='run_data_rln2.star';
my $out='run_data_rln2_coords.star';
open (IN,$in) or die "no read\n";
open (OUT,">$out") or die "no write\n";
while (<IN>) {
   my @data=split(" ",$_);
   if ($#data > 15) {
      for (my $i=0; $i<=5; $i++) {
         print OUT "$data[$i] ";
      }
      print OUT "$data[6].mrc\n";
   }
   elsif (m/_rlnCoord/ or m/_rlnAngle/ or m/^data_/ or m/^loop_/ or m/^#/) {
      print OUT;
   }
   elsif (m/_rlnTomoName/) {
      print OUT "_rlnMicrographName #7\n";
   }
}
