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

my @warpfiles=glob("goodparticles_Box*.star");
my $warpfile=$warpfiles[0];
print "Warp picks found:\n"; foreach $f (@warpfiles) {print "$f\n";} ; print"\n";
#print "Enter warpfile (default $warpfile): ";
#chomp ($line=<STDIN>);
#if ($line) {$warpfile=$line;}
 
open (IN,$warpfile) or die "Cannot read $warpfile \n";
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
 
