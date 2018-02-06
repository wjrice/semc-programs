#! /usr/bin/perl -w
# script to make links in current directory for all boxfiles and
# matching mrc files in specified directory
# wjr 11-13-15

use File::Basename;
print "enter directory to scan for boxfiles: ";
chomp (my $boxdir = <STDIN>);
print "Enter directory for mrc files: ";
chomp (my $mrcdir=<STDIN>);
my @files = glob("${boxdir}/*.box");
foreach $file (@files) {
   my $boxfile = basename ($file);
   my @data = split /\.box/,$boxfile;
   my $mrcfile = $data[0] . '.mrc';
   my $mrcfull = $mrcdir . '/' . $mrcfile;
   if (-e $mrcfull) {
      print "found $mrcfile for $file\n";
      symlink $file,$boxfile;
      symlink $mrcfull , $mrcfile;
   }
   else {
      print "MISSING mrc file $mrcfile for $file!\n";
   }
}

