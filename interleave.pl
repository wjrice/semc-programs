#! /usr/bin/perl -w
use strict;

# interleave.pl -- to interleave two mrc stacks, probably from overlapping serial sections
# usage: interleave.pl [filename1] [filename2] [outputfile]
# needs to have imod installed and working. Requires use of header and newstack programs.
# wjr 043013

my ($filename1,$numsections,$numsections2,$filename2,$line,$outfile);
if ($ARGV[0] and $ARGV[1]) { 
   $filename1 = $ARGV[0];
   $filename2 = $ARGV[1];

}
else
{  
   print "Interleave.pl : interleaves two equally sized mrc stacks \n";
   print "Usage: interleave.pl [filename1] [filename2] [outputfile]\n";
   print "Enter first stack filename for extraction: ";
   chomp ($filename1=<STDIN>); 
   print "Enter second stack filename for extraction: ";
   chomp ($filename2=<STDIN>); 
}
unless (-e $filename1) {die "Cannot find file $filename1! Exiting\n";}
unless (-e $filename2) {die "Cannot find file $filename2! Exiting\n";}

if ($ARGV[2]) {
   $outfile=$ARGV[2];
}
else {
   print "Enter name for combined file: ";
   chomp ($outfile=<STDIN>);
}

my @splitname = split (/\./,$filename1);
my $base=$splitname[0] . "_";

my @header = `header $filename1`;
foreach $line(@header) {
    if ($line =~ m/Number of columns/) {
	$line =~ m/(\d+)\s+(\d+)\s+(\d+)$/;
	$numsections=$3;
	last;
    }
}
@header = `header $filename2`;
foreach $line(@header) {
    if ($line =~ m/Number of columns/) {
	$line =~ m/(\d+)\s+(\d+)\s+(\d+)$/;
	$numsections2=$3;
	last;
    }
}

if ($numsections) { print "Number of sections in file1: $numsections \n";}
else { die "Could not get number of sections from header!\n";}
unless ($numsections == $numsections2) {
   die "Number of sections in file 2, $numsections2, is not equal to that in file 1\n";
}

my $totalsecs = 2*$numsections;
open (FILEIN1,">fileinlist.tmp") or die "Could not write fileinlist.tmp\n";
print FILEIN1 $totalsecs, "\n";
for (my $i=0; $i<$numsections; $i++) {
    print FILEIN1  "$filename1\n";
    print FILEIN1  "$i \n";
    print FILEIN1  "$filename2\n";
    print FILEIN1  "$i \n";
}
close (FILEIN1);

system "newstack -fileinlist fileinlist.tmp $outfile";
#unlink "fileinlist.tmp";
