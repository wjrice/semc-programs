#! /usr/bin/perl -w
# script to combine pick coordinates from many star files into a single star file
# for cryolo and possibly appion star export
# note that there is no ctf or other data, only pick coordinates
# wjr 11-08-22
#

my @files=glob("STAR/*.star");
my $outfile = 'picks.star';
open (OUT,">$outfile") or die "cannot write $outfile\n";
print OUT << "EOF";

data_

loop_
_rlnCoordinateX #1
_rlnCoordinateY #2
_rlnMicrographName #3
EOF

foreach my $file (@files) {
   print "working on $file\n";
   my $filename = $file;
   $filename =~ s/star/mrc/;
   $filename =~ s/STAR\///;
   open (IN,$file) or die "cannot read $file\n";
   while (<IN>) {
      next if (m/_/) ;
      my @data=split(" ",$_);
      next unless ($#data >0);
      print OUT "$data[0] $data[1] $filename\n"
   }
   close (IN);
}
 
