#! /usr/bin/perl -w

# stackmrc_dualtilt.pl -- to stack all mrc files in current directory into two stacks, for dual-tilt processing
# usage: stackmrc_dualtilt.pl
# needs to have imod installed and working. Requires use of newstack programs.
# output stacks are called stack.mrc and stack2.mrc
# can be combined with newstack -twodir option, in which you specify 2 input files, the first of which is 
#  reversed by the program to make a continuous stack
# note: if tilt series collects 2 zero-degree images, you should delete the second one
# wjr 021116


my @files=glob("*.mrc");
my $totalnumsections=$#files+1;
my $outfile='stack.mrc';
my $outfile2= 'stack2.mrc';
my $file;

#if  ($ARGV[0]) {
#    $outfile= $ARGV[0];
#}

print "Assuming double tilt series.\n";
print "Enter image number for last image of tilt1: ";
chomp ($last=<STDIN>);
my $filenum2 = $totalnumsections - $last;

if ($files[0] =~ m/(^.*)_\d\d\d\.mrc/) {
   $pattern = $1;
   print "pattern = $pattern\n";
}


open (FILEIN1,">fileinlist1.tmp") or die "Could not write fileinlist1.tmp\n";
print FILEIN1 $last, "\n";
open (FILEIN2,">fileinlist2.tmp") or die "Could not write fileinlist2.tmp\n";
print FILEIN2 $filenum2, "\n";
foreach $file (@files) {
    $file =~ m/${pattern}_(\d\d\d)\.mrc/;
    $filenum = $1; 
    if ($filenum <= $last) {
       print FILEIN1  "$file\n";
       print FILEIN1  "0 \n";  #assume input is not a stack -- need first image only
   }
   else {
       print FILEIN2  "$file\n";
       print FILEIN2  "0 \n";  #assume input is not a stack -- need first image only
   }
}
close (FILEIN1);
close (FILEIN2);

system "newstack -fileinlist fileinlist1.tmp $outfile";
system "newstack -fileinlist fileinlist2.tmp $outfile2";
#unlink "fileinlist.tmp";
