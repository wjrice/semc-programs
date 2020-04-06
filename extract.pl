#! /usr/bin/perl -w
use strict;

# extract.pl -- to extract all files from SerialEM stack and save in mrc format
# usage: extract.pl [filename]
# needs to have imod installed and working. Requires use of header and newstack programs.
# wjr 050407

my ($filename,$numsections,$line);
if ($ARGV[0]) 
{ $filename = $ARGV[0];}
else
{  
   print "Extract.pl : extracts all mrc files from a SerialEM stack (.st) file\n";
   print "Usage: extract.pl [filename]\n";
   print "Enter stack filename for extraction: ";
   chomp ($filename=<STDIN>); 
}
unless (-e $filename) {die "Cannot find file $filename! Exiting\n";}

my @splitname = split (/\./,$filename);
my $base=$splitname[0] . "_";

my @header = `header $filename`;
foreach $line(@header) {
    if ($line =~ m/Number of columns/) {
	$line =~ m/(\d+)\s+(\d+)\s+(\d+)$/;
	$numsections=$3;
	last;
    }
}
if ($numsections) { print "Number of sections in file: $numsections \n";}
else { die "Could not get number of sections from header!\n";}

open (FILEIN1,">fileinlist.tmp") or die "Could not write fileinlist.tmp\n";
open (FILEOUT1,">fileoutlist.tmp") or die "Could not write fileoutlist.tmp\n";
print FILEIN1 $numsections, "\n";
print FILEOUT1 $numsections, "\n";
for (my $i=0; $i<$numsections; $i++) {
    print FILEIN1  "$filename\n";
    print FILEIN1  "$i \n";
    printf FILEOUT1  ("%s%.4d.mrc\n",$base,$i);
    print FILEOUT1  "1\n";
}
close (FILEOUT1);
close (FILEIN1);

system "newstack -fileinlist fileinlist.tmp -fileoutlist fileoutlist.tmp";
unlink "fileinlist.tmp";
unlink "fileoutlist.tmp";
