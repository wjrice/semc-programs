#! /usr/bin/perl -w
#
my $warpset='goodparticles_BoxNet2_20180602.star';
my $csparcset='particles_selected.star';
my $outstar='good_for_import.star';

if ($ARGV[0]) {
   $csparcset=$ARGV[0];
}
print "Converting data from $csparcset\n";

my %stardata;
open (IN,$warpset) or die "cannot read $warpset\n";
open (OUT,">$outstar") or die "cannot write $outstar\n";
while (<IN>) {
   my @data=split(" ",$_);
   if ($#data <4) { #header line
      print OUT;
      if ($_=~m/_rlnImageName.*#(\d+)/) {
         $particlecol = $1 -1;
         print "found particlecol at $particlecol\n";
      }
   }
   else {
      my $particle = $data[$particlecol];
      $stardata{$particle} = $_; #save the whole line
   }
}
close (IN);
my @keys = keys(%stardata);
print "found $#keys particles \n";
print "last particle is $stardata{$keys[$#keys]}\n";
open (IN,$csparcset) or die "cannor read $csparcset\n";
while (<IN>) {
   s/J\d+\/imported/particles/;
   my @data=split(" ",$_);
   next unless ($#data>4);
   my $particle=shift(@data);
   $particle = '0' . $particle;  #cryosparc has one fewer digit in the programmed partlcle number
   print OUT $stardata{$particle};
   $outnum++;
}
close (IN);
close (OUT);
print "Wrote $outnum particles\n"

