#! /usr/bin/perl -w
# program to plot guinier plots from start files
# made from relion 1.4 particle polishing
# run in the directory which has the guinier star files
# outputs png files for each plot, including points and linear lwast squares fit of data
# wjr 11-28-15

use Scalar::Util qw(looks_like_number);
my $gnu = 'plotgnu'; #output gnuplot control file

my @files=glob("*guinier.star");
foreach $file(@files) {
   my @data=split /star/,$file;
   my $fileout = $data[0] . 'plt';
   my $plotout = $data[0] . 'png';
   open (OUT,">$fileout") or die "cannot write $fileout\n";
   open (IN,$file) or die "cannot read $file\n";
   while (<IN>) {
      @data=split;
      if (looks_like_number($data[0]) ) {
         print OUT "$data[0] $data[1] \n";
      }
   }
   close (IN);
   close (OUT);
   open (OUT,">$gnu") or die "canot write\n";
   print OUT << "EOF"; 
m=0.0
b=0.0
f(x) = m*x + b
fit f(x) '$fileout' via m,b
#ti = sprintf ("Slope of fitted line: %.3f", m  )
set term png
set output "$plotout"
#plot '$fileout' title "$fileout" , f(x) title ti
plot '$fileout' title "$fileout" , f(x) title "fit"
replot
q
EOF
close (OUT);
   `gnuplot $gnu`;
   unlink $fileout;  #comment out if you want to keep raw plot data
}


