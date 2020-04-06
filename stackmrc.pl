#! /usr/bin/perl -w
use strict;

# stackit.pl -- to stack all mrc files in current directory into a stack
# usage: extract.pl [outstack]
# needs to have imod installed and working. Requires use of header and newstack programs.
# wjr 031615


my @files=glob("*.mrc");
my $numsections=$#files+1;
my $outfile='stack.mrc';
my $file;

if  ($ARGV[0]) {
    $outfile= $ARGV[0];
}


open (FILEIN1,">fileinlist.tmp") or die "Could not write fileinlist.tmp\n";
print FILEIN1 $numsections, "\n";
foreach $file (@files) {
    print FILEIN1  "$file\n";
    print FILEIN1  "0 \n";  #assume input is not a stack -- need forst image only
}
close (FILEIN1);

system "newstack -fileinlist fileinlist.tmp $outfile";
unlink "fileinlist.tmp";
