#! /usr/bin/perl -w
# script to make a histogram of particle defocus after sorting
# need to save output from sort_defocus.pl into a text file
#
my $infile = 'sort.log';
my $outfile = 'histo.tmp';
my $plotfile = "part_df_histo.png";
print "Enter input file (default $infile): ";
chomp (my $line=<STDIN>);
if ($line) {$infile=$line;}

open (IN,$infile) or die "cannot read $infile\n";
open (OUT,">$outfile") or die "cannot write $outfile\n";
my $count=0;
while ($line=<IN>) {
   @data=split(" ",$line);
   next unless ($#data ==9);
   $numpart = $data[3];
   $avg_df= ($data[7] + $data[9])/2;
#   if ($numpart >0) { #skip groups with no particles
      print OUT "$count $avg_df  $numpart\n";
      $count++;
 #  }
}
close (OUT);
close (IN);
open (OUT,">plotgnu");
print OUT "set boxwidth 0.5\n";
print OUT "set style fill solid\n";
print OUT "set xtics rotate\n";
print OUT qq(set ylabel "Number of Particles"\n);
print OUT qq(set xlabel "Defocus /A"\n);
print OUT "set term png\n";
print OUT qq(set output "$plotfile"\n);
print OUT qq(plot "$outfile" using 1:3:xtic(2) with boxes notitle\n);
close (OUT);
`gnuplot plotgnu`;
#clean up
unlink $outfile;
unlink 'plotgnu';
print "made output plot $plotfile\n";
 



