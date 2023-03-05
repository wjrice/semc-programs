#! /usr/bin/perl -w
#
my $infile;
if ($ARGV[0]) {
   $infile=$ARGV[0];
}
else {
   print "enter file: ";
   chomp ($infile=<STDIN>);
}

open (IN,$infile) or die "can\'t write $infile\n";
my $outfile = $infile . '.tmp';
open (OUT,">$outfile") or die "cannot write $outfile\n";
while (<IN>) {
      $_ =~ s/J\d+\/imported\/\d+_//ig;
      print OUT;
}
close (IN);
close (OUT);
rename $infile, "$infile.orig";
rename $outfile, $infile;


