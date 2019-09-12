#! /usr/bin/perl -w
#
# to remove duplicate entries in a star file
# first file is a subset of second file
# output will contain the exclusion
# wjr 030918
#
my @starfiles = glob("*.star");
my $file;
print "\nstarfiles in folder:\n";
foreach $file (@starfiles) {print "$file\n";}
print "\nEnter smaller star file: ";
chomp (my $starfile1 = <STDIN>);
print "Enter larger star file: ";
chomp (my $starfile2 = <STDIN>);
print "Enter output starfile: ";
chomp (my $starfile3 = <STDIN>);
my @keys;
my $total=0;

open (IN,$starfile1) or die "cannot read $starfile1\n";
open (OUT,">$starfile3") or die "cannot write $starfile3\n";
while (<IN>) {
   @data = split(" ",$_);
   if ($#data <2) {
      print OUT;
   }
   else {
      push @keys, $data[0];
   }
}
close (IN);

my $unique=0;
open (IN,$starfile2) or die "cannot read $starfile2\n";
while (<IN>) {
   @data = split(" ",$_);
   next unless ($#data >2);
   $total++;
   my $skip=0;
   for (my $i=0; $i <= $#keys; $i++) {
      if ($data[0] eq $keys[$i]) {
         $skip=1;
         splice @keys, $i, 1;  #delete this item from array
         last; #no need to continue searching
      }
   }
   unless ($skip) {print OUT; $unique++;}
}
print "Wrote out $unique lines from an original list of $total\n";
      
   
