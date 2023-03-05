#! /usr/bin/perl -w
my $file = 'exemplar.txt';
if (defined $ARGV[0]) {$file=$ARGV[0];}
open (IN,$file) or die "cannot read $file, specify input file on command line\n";
while (<IN>) {
   chomp;
   `ln -s ../rawdata/$_ .`;
}

