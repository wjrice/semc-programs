#! /usr/bin/perl -w
#
# script to remove the extra junk that cryosparc adds
# replaces imported micrograph path with Micrographs
# replaces imported particles path with paticles

unless (defined $ARGV[0]) {
   die "Usage: remove_junk.pl <star file>\n";
}
my $infile = $ARGV[0];
my $outfile = $infile . ".temp";
open (IN,$infile) or die "cannot read $infile\n";
open (OUT,">$outfile") or die "cannot write $outfile\n";

while (<IN>) {
   $_ =~ s/\@J\d+\/imported\/\d+_/\@particles\//;
   $_ =~ s/ J\d+\/imported\/\d+_/ Micrographs\//;
   print OUT;
}
close (IN);
close (OUT);
rename ($infile, "$infile.orig") or die "Can't rename $infile to $infile.orig: $|";
rename ($outfile, $infile) or die "Can't rename $outfile to $infile: $|";

