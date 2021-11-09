#! /usr/bin/perl -w
#to split a single giant mdoc file into multiple files, one per navigator item
#needed for old SerialEM collections
# wjr 022321
#
#------ set these parameters -----
my $file = 'tomoreal.st.mdoc';
my $outname = 'polartube_';  
#-----------    -----------------


my @header = ();
my @data = ();
my $filenum;

open (IN,$file) or die "Cannot read $file\n";
for (my $i=0; $i<10; $i++) {
   $header[$i] = <IN>;
}

my $navnum = -1;  #this will never be a real navigator number
open (OUT, ">tmp.txt"); # need to start with a junk file, which will be empty
while (<IN>) {
   push @data, $_; # cache until we know where to write it
   if ($_ =~ /NavigatorLabel = (\d+)/) {
       $filenum =$1;
      if ($filenum  == $navnum) {
         foreach my $line (@data) {
            print OUT $line;
         }
         @data=();  #clear the data after writing
      }
      else {# open a new file for a new navigator item
         close OUT;
	 $navnum = $filenum;
         my $outfile = $outname . $navnum . '.st.mdoc';
         print "WRITING $outfile\n";
         open (OUT,">$outfile") or die "Cannot write $outfile\n";
         $header[2] = 'ImageFile = ' . $outname . $navnum . ".st\n";
         foreach my $line (@header) {
            print OUT $line;
         }
         foreach my $line (@data) {
            print OUT $line;
         }
         @data = (); #clear the data after writing
      }
   }
}
unlink "tmp.txt";  # remove the junk file

