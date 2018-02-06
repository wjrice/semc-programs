#! /usr/bin/perl -w
#check range f defocus values found in starfile from local gctf
#wjr 10-08-17
#
my @files = glob("micrographs/*local.star");
my %min;
my %max;
foreach $file (@files)  {
   open (IN,$file) or die "Cannot read $file\n";
   while (<IN>) {
      next unless ($_ =~ m/micrographs/); 
      @data = split(" ",$_);
      $name = $data[0];
      $df = ($data[4] + $data[5])/2;
      if ($min{$name}) {
         if ($df < $min{$name}) {$min{$name} = $df;}
         if ($df > $max{$name}) {$max{$name} = $df;}
      }
      else {
         $min{$name} = $df;
         $max{$name} = $df;
      }
   }
   close (IN);
}
@keys = sort keys %min;
foreach $key (@keys) {
   $diff = $max{$key} - $min{$key};
   printf ("%s : min = %8.1f max = %8.1f  diff = %8.1f\n", $key,$min{$key},$max{$key},$diff);
}



