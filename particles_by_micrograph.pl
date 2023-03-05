#! /usr/bin/perl -w
# reads in a particles star file, outputs a list and plot of particles per micrograph
# wjr 022517
#

my $input = 'particles.star';
my $output = 'mic_ptcls.txt';
my $plotfile = "part_histo.png";
my $plotfile2 = "defocus_histo.png";
my $output2 = 'defocus_ptcls.txt';

print "Enter input file (default $input): ";
chomp (my $line=<STDIN>);
if ($line) {$input = $line;}
open (IN,$input) or die "cannot read\n";


$line=<IN>; #skip optics table
while ($line !~ m/data_particles/) {
   $line= <IN>;
   } 

$line=<IN>;
while ($line !~ m/loop/) {
   $line= <IN>;
   } 

#read header
$line = <IN>;
while ($line =~ m/_rln(\w+)\s\#(\d+)/) {
   $type=$1;
   $itemnum=$2;
   $header{$type} = $itemnum -1 ; #array numbers start at 0 while relion starts at 1
   chomp $line; 
#   print "header $line type $type itenmum $itemnum\n";
   $line = <IN>;
}

my @keys = sort keys (%header);
#print "keys found in header: @keys\n";

my @data=split(" ",$line);
my %count;
my %count_df;
my $total=0;
while ($#data>2) {
   $micrograph =$data[$header{'MicrographName'}];
   $defocus = ($data[$header{'DefocusU'}] + $data[$header{'DefocusV'}]) / 2;
   $defocus = int($defocus/100) * 100;
   unless ($count_df{$defocus}) {$count_df{$defocus}=0;}
   $count_df{$defocus} += 1;  
   unless ($count{$micrograph}) {$count{$micrograph}=0;}
   $count{$micrograph} += 1;  
   $total += 1;
   $line = <IN>;
   @data=split(" ",$line);
}
close (IN);

open (OUT,">$output") or die "cannot write to $output\n";
@keys = sort keys (%count);
$i=1;
#print "Index  Micrograph  Num Particles\n";
foreach $key (@keys) {
   print OUT "$i $key $count{$key}\n";
   $i++;
}
close (OUT);

open (OUT,">$output2") or die "cannot write to $output2\n";
@df_keys = sort {$a <=> $b} keys (%count_df);
$i=1;
#print OUT "Defocus Range  Num Particles\n";
foreach $key (@df_keys) {
   my $range = $key+99;
   print OUT "$key $key-$range  $count_df{$key}\n";
   $i++;
}
close (OUT);

open (OUT,">plotgnu");
print OUT "set boxwidth 0.5\n";
print OUT "set style fill solid\n";
print OUT "set xtics rotate\n";
print OUT qq(set ylabel "Number of Particles"\n);
print OUT qq(set xlabel "Micrograph"\n);
print OUT "set term png\n";
print OUT qq(set output "$plotfile"\n);
print OUT qq(plot "$output" using 1:3 with boxes notitle\n);
close (OUT);
`gnuplot plotgnu`;

open (OUT,">plotgnu");
print OUT "set boxwidth 0.5\n";
print OUT "set style fill solid\n";
print OUT "set xtics rotate\n";
print OUT qq(set ylabel "Number of Particles"\n);
print OUT qq(set xlabel "Defocus range"\n);
print OUT "set term png\n";
print OUT qq(set output "$plotfile2"\n);
print OUT qq(plot "$output2" using 1:3 with boxes notitle\n);
close (OUT);
`gnuplot plotgnu`;



#clean up
unlink 'plotgnu';
print "\n\nWrote micrograph listing to $output\n";
print "Wrote defocus listing to $output2\n";
print "made output micrograph plot $plotfile\n";
print "made output defocus plot $plotfile2\n";
my $avg = $total / ($#keys+1);
printf ("Total particles: $total \t\t Average particles per micrographs: %0.1f\n",$avg);
printf ("Number of micrographs: %i\n",$#keys+1);

