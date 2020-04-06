#! /usr/bin/perl -w
#
open (IN,'initial.star') or die "cannot read initial.star\n";
open (OUT,">good_unique.star") or die "no write\n";
my %set;
while (<IN>) {
   my @data=split(" ",$_);
   if ($#data<3) {
      next;
   }
   else {
      my $micrograph=pop @data;
      $set{$micrograph} = 1;
   }
}
close (IN);

open (IN,"goodparticles_BoxNet2_20180602.star") or die "no read goodparticles_BoxNet2_20180602.star\n";
while (<IN>) {
   my @data=split(" ",$_);
   if ($#data<3) {
      print OUT;
   }
   else {
      $micrograph=$data[$#data];
      unless (defined $set{$micrograph}) {
         print OUT;
       }
   }
} 
close(OUT);

my @keys =sort keys (%set);
my $count = $#keys+1;
print "removed $count micrographs\n";
#foreach $name (@keys) {
#   print OUT "$name $df1{$name} $df2{$name} $dfa{$name} $sa{$name} $ps{$name} $ac{$name}\n";
#}
#close (OUT);
 
