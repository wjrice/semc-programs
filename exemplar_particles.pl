#! /usr/bin/perl -w
#
# to select a subset of particles which match an exemplar list
# tries to nbe smart to automatically find the exemplar file and the warp file
# outputs "warp_exemplar_particles.star"
# wjr 03-27-24
#
my @exemplar = glob("*exemplar*txt");
my $exemplar = pop @exemplar;
my @warp = glob("good*.star");
my $warp = pop @warp;
my $outfile = "warp_exemplar_particles.star";
`grep -v mrc $warp > $outfile`;
open (IN,$exemplar) or die "cannot open $exemplar\n";
while (<IN>) {
   chomp;
   `grep $_ $warp >> $outfile`;
}


