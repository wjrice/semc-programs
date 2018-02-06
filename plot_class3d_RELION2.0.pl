#! /usr/bin/perl -w
# plots the 3d classification results: Accuracy of rorations, accuracy of translations, class distribution, and resolution
# modifed 4-2-17 for Relion 2.0 directory structures
# wjr 
#
my $prefix = "Class3D/run1";
print "\nClass3D directory contents: \n";
my @dir=`ls -1 Class3D`;
print @dir;

print "Enter directory to plot: ";
chomp ($line=<STDIN>);
if ($line) {$prefix = 'Class3D/' . $line . '/run';}; # designed for Relion2 directory structure
my $fileout = $prefix . "Class3d.plt";

my @files = glob("${prefix}_it???_model.star");
die "Cannot find any files matching ${prefix}_???_model.star \n" unless (@files);
open (OUT,">$fileout") or die "cannot write\n";

$filenum = 0;
foreach $file (@files) {
   $file =~ m/_it(\d+)_/;
   $iteration = $1;
   if ($iteration>0) {print OUT "$iteration ";}
   open (IN,$file) or die "cannot read $file\n";
   my $line = <IN>;
   while ($line !~ m/data_model_classes/)  {
      if ($line =~ m/_rlnCurrentResolution\s+(\d+\.\d+)/) {
         $resolution = $1;
      }
      if ($line =~ m/_rlnNrClasses\s+(\d+)/) {
         $num_models=$1;
      }
      $line = <IN>;
   }
   # xf ($line =~ m/data_model_classes/)  #found the final pieces we want
   while ($line !~ m/loop_/) {
      $line = <IN>;
   }
   $line=<IN>;
   while ($line =~ m/_rln(\w+)/) {
      if ($filenum <1) {push @keys,$1;}
      $line = <IN>;
   }
   @data = split (" ",$line);
   while ($#data == $#keys) {
      $data[0] =~ s/_/-/g;
      push @plotnames, $data[0] unless ($filenum >0);
      print OUT "$data[1] $data[2] $data[3] " unless ($iteration <1);
      $line=<IN>;
      @data = split(" ",$line);
   }
   close (IN);
   if ($resolution) { print OUT " $resolution\n";} 
   $filenum ++;
}
close (OUT);
for ($j=1; $j <= $#keys; $j++) {
   open (OUT2,">plotgnu");
#   print OUT2 "set term png\n";
   print OUT2 "set term png  font '/usr/share/fonts/liberation/LiberationSans-Regular.ttf' 12\n";
   print OUT2 "set output \"${prefix}_$keys[$j].png\"\n";
   print OUT2 "set xlabel \"Iteration\" \n";
   print OUT2 "set ylabel \"$keys[$j]\" \n";
   if ($keys[$j] =~ m/otation/) { $yrange = 8;}
   elsif ($keys[$j] =~ m/anslation/) {$yrange = 5;}
   elsif ($keys[$j] =~ m/istribu/) {$yrange = 1;}
   print OUT2 "set yrange [0:$yrange]\n";
   for ($i=0; $i < $num_models; $i++) {
      $coladd = $i*($#keys);
      $col = $coladd+$j+1;
      if ($i>0) {print OUT2 ", ";} else {print OUT2 "plot ";}
      print OUT2 "\"$fileout\" using 1:$col with linespoints lw 2 ti \"$plotnames[$i]\"  ";
   }
   print OUT2 "\n";
   close (OUT2);
   `gnuplot plotgnu`;
}

$last_col = $num_models * ($#keys) +2;
open (OUT2,">plotgnu");
#print OUT2 "set term png\n";
print OUT2 "set term png  font '/usr/share/fonts/liberation/LiberationSans-Regular.ttf' 12\n";
print OUT2 "set output \"${prefix}_class3d_resolution.png\"\n";
print OUT2 "set xlabel \"Iteration\"\n";
print OUT2 "set ylabel \"Resolution (A)\" \n";
print OUT2 "set yrange [0:] \n";
print OUT2 "plot \"$fileout\" using 1:$last_col with linespoints lw 2 ti \"Class Resolution\" \n";
close OUT2;
`gnuplot plotgnu`;
 
print "plotted data from $filenum files\n ";
print "To view, copy and paste following line:\n";
print "eog Class3D/$line/*.png\n";

foreach $key (@keys) {print "$key\n";}
