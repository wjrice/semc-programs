#! /usr/bin/perl -w
# script to find ctffind4 results with fits worse than 10A
# assumes all results in Micrographs folder
# option to move mrc and box files with "bad" ctf to Micrographs/bad (automatically made)
# note: ctf output files are not moved, therefore these will be detected again if re-run.
# wjr 12-20-15

my $limit = 10 ; #limit for bad fit in A
my @files = glob("Micrographs/*.log");
my $eliminate=0;

print "Move bad files (mrc,box) to temporary folder?";
chomp ($answer = <STDIN>);
if ($answer =~ m/[yY]/) {   
   $eliminate=1;
   `mkdir Micrographs/bad`;   
}

foreach $file (@files) {
   open (IN,$file) or die "cannot read $file\n";
   while ( $line=<IN> ) {
      if ($line =~ m/Thon/) {
         @data = split (" ",$line);
         $i = $#data;
         while ($i>0 and $data[$i] !~ /Angstrom/) {$i--;}
         die "Thon pattern not matched in file $file\n" unless ($i > 0);
         $bestres = $data[$i-1];      
         if ($bestres > $limit) {
            print "Bad CTF for file $file: Thon rings only good to $bestres Angstroms\n";
            if ($eliminate) {
               $base = $file;
               $base =~ s/_ctffind3.log//;
               `mv ${base}.mrc Micrographs/bad/.`;
               `mv ${base}.box Micrographs/bad/.`;
            }       
         }
         last; #stop reading file, we already matched the line we wanted
      }
   } 
   close (IN);
}
