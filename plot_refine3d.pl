#! /usr/bin/perl -w
#
# plots the resolution by iteration from relion 2.0 3D refinement
# wjr 4-2-17
#
my (@resolutions,@angles,@offsets,$line);
my $temp = 'tmp.txt'; #temporary file for writing plot data
print "Refine3D directory contents: \n";
my @dir=`ls -1 Refine3D`;
print @dir;
print "Enter job directory: ";
chomp (my $jobdir=<STDIN>);
open  (IN, "Refine3D/$jobdir/run.out") or die "Cannot find Refine3D/$jobdir/run.out \n";
while ($line=<IN>) {
   if ($line =~ m/Resolution= (\d+\.\d+) Angstrom/) {
      push @resolution,$1;
   }
   if ($line =~ m/Final resolution \(without masking\) is: (\d+\.\d+)/) {
      push @resolution, $1;
   }
   if ($line =~ m/accuracy angles= (\d+\.\d+)/) {
      push @angles,$1;
   }
   if ($line =~ m/offsets= (\d+\.\d+)/) {
      push @offsets,$1;
   }
}
close (IN);

&write_array($temp,@resolution);  #output file, array to write
&plot_curve ("Refine3D/$jobdir/Resolution",$temp,2);  #title, filename, last column [usu. 2]
&write_array($temp,@angles);  #output file, array to write
&plot_curve ("Refine3D/$jobdir/Accuracy_angles",$temp,2);  #title, filename, last column [usu. 2]
&write_array($temp,@offsets);  #output file, array to write
&plot_curve ("Refine3D/$jobdir/Offsets",$temp,2);  #title, filename, last column [usu. 2]

print "To view, copy and paste following command:\n";
print "eog Refine3D/$jobdir/*.png \n";

sub write_array {
   my $tempfile= shift;
   open (OUT,">$tempfile") or die "cannot write temporary file $tempfile\n";
   for ($i=0; $i <=$#_; $i++) {
      print OUT "$i $_[$i]\n";
   }
   close (OUT);
}
 
sub plot_curve {
   # parameter order: name of curve, file to plot, column number to plot
   #  uses gnuplot
   #  deletes plotted file and temporary gnuplot command file at end
   my $name = shift;
   my $file = shift;
   my $col = shift;
   my $plotname = $name . '.png';
   open (OUT2, ">plotgnu") or die "cannot write to plotgnu\n";
   open (OUT2,">plotgnu");
   print OUT2 "set term png size 800,600 font '/usr/share/fonts/liberation/LiberationSans-Regular.ttf' 12\n";
#   print OUT2 "set term png\n";
   print OUT2 "set output \"$plotname\"\n";
   print OUT2 "set xlabel \"Iteration\"\n";
   print OUT2 "set ylabel \"$name\" \n";
   print OUT2 "set yrange[0:]\n";
   print OUT2 "plot \"$file\" using 1:$col with linespoints lw 2 ti \"$name\" \n";
   close OUT2;
   `gnuplot plotgnu`;
 
   print "plotted data from file $file into $plotname\n "; 
   unlink $file; #clean up
   unlink 'plotgnu';
}
