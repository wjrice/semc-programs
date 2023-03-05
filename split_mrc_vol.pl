#! /usr/bin/perl -w
#
use POSIX;  # for ceiling function
my @files;  # file list to be processed
my $input = "22nov22a_tomo03.st_rec.mrc";
my $nframes=500;
my $z_sum=4;
my $z_input;
if (defined $ARGV[0]) {
   $input = $ARGV[0];
}
else {
   print "Enter tomogram name, or ALL for all files: ";
   chomp ($input = <STDIN>);
}
if (defined $ARGV[1]) {
   $z_sum = $ARGV[1];
}
else {
   print "Enter number of z-sections to sum (default $z_sum): ";
   chomp ($z_input = <STDIN>);
}
if ($z_input) {
   $z_sum=$z_input;
}
#$z_sum = int($diameter/2 + 0.5); 
if ($input eq 'ALL') {
   @files = glob("*.mrc");
}
else {
   push @files,$input;
}

foreach my $input (@files) {
   my @header = `header $input`;
   foreach my $line (@header) {
      if ($line =~ m/sections/) {
         my @data = split(" ",$line);
         $nframes = pop @data;
         last;
      }
   }

   my $nfiles = ceil($nframes/$z_sum);
   unless (-e 'split') {mkdir 'split';}
   for (my $i=0; $i<$nfiles; $i++) {
      my $start = $z_sum * $i;
      my $end = $z_sum * ($i + 1) -1;
      if($end >= $nframes) {  # bottom section may be shorter
         $end = $nframes -1;
      }
      my $startstr = sprintf("%.3i",$start);
      my $endstr = sprintf("%.3i",$end);
      my $output = $input;
      $output =~ s/.mrc//;
      $output .=  $startstr . '-' . $endstr . '.mrc';
      print "clip average -2d -iz $start,$end $input $output\n";
      `clip average -2d -iz $start,$end $input split/$output`;
   }
}
 
