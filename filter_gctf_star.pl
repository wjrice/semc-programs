#! /usr/bin/perl -w
my $in='micrographs_all_gctf.star';
my $out = 'micrographs_filt_gctf.star';
my $max_ctf = 5 ; #max ctf allowed, in A

open (IN,$in) or die "cannot read";
open (OUT,">$out") or die "cannot write\n";
while (<IN>) {
   @data =split(" ",$_);
   if ($#data<10) {
      print OUT $_;
   }
   else { #data here
      $lines_in++;
      $res = $data[$#data];
      if ($res <= $max_ctf) {
         print OUT $_;
         $lines_out++;
      }
   }
}
print "Filtered all to $max_ctf or better. $lines_out micrographs passed out of $lines_in\n";

