#! /usr/bin/perl -w
#
#script to throw away any motion corrected files where Relion could not fine a trajectory
#presume these are bad, must have no or too-low signal, so elimintate right away
#
# wjr 09-16-2019
#
open (IN,"run.err") or die "cannot open run.err\n";
my %badfiles;
while (<IN>) {
	if ($_ =~ m/too few valid local trajectories/) {
		my @data=split(/:/,$_);
		if ($data[0] =~ m/\/(\S+)\.tif/) {
			$badfile = $1;
			$badfile .= '.mrc';
			$badfile =~ s/\.frames/_frames/;
			$badfiles{$badfile} = 1;
		}
		else {
			print "regex failed for $data[0] \n";
		}
	}
}
close (IN);

my @keys = keys %badfiles;
foreach $key (@keys) {
   print "$key\n";
   $i++;
}
print "nbad = $i\n";

open (IN,"corrected_micrographs.star") or die "cannot open corrected_micrographs.star\n";
open (OUT,">good_corrected_micrographs.star") or die "cannot write good_corrected_micrographs.star\n";
while (<IN>) {
	my @data=split(" ",$_);
	if ($#data < 4) {print OUT;}
	else {
		my @data2 = split(/\//,$data[0]);
		my $file = pop @data2;
		unless (defined $badfiles{$file}) {
			print OUT;
		}
	}
}

