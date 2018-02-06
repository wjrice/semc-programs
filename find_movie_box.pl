#! /usr/bin/perl -w
# script to make links in current directory for all boxfiles and
# matching mrc moviefiles in specified directory
# wjr 11-13-15
# modded 11-24-15 for movies

use File::Basename;
print "enter directory to scan for boxfiles: ";
chomp (my $boxdir = <STDIN>);
print "Enter directory for movie files: ";
chomp (my $mrcdir=<STDIN>);
my @files = glob("${boxdir}/*.box");
foreach $file (@files) {
   my $boxfile = basename ($file);
   my $moviefile = $boxfile;
   $moviefile =~ s/-a\.box/_st.mrc/ ;
#   my @data = split /\.box/,$boxfile;
#   my $mrcfile = $data[0] . '.mrc';
   my $moviefull = $mrcdir . '/' . $moviefile;
   if (-e $moviefull) {
      print "found $moviefile for $file\n";
      print" symlink $file,$boxfile\n";
#      symlink $file,$boxfile;
      $moviefile =~ s/_st\.mrc/-a_movie.mrcs/;
      print "symlink $moviefull , $moviefile\n";
      symlink $moviefull , $moviefile;
   }
   else {
      print "MISSING mrc file $moviefile for $file!\n";
   }
}

