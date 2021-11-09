#! /usr/bin/perl -w
#
unless ($ARGV[0] and $ARGV[1]) {die "Usage: $0 <input star file> <output star file>\n";}
my $instar = $ARGV[0];
my $outstar=$ARGV[1];

open (IN,$instar) or die "cannot read $instar\n";
open (OUT,">$outstar") or die "cannot write $outstar\n";
while (<IN>) {
   s/J\d+\/imported/Micrographs/;
   print OUT;
}

