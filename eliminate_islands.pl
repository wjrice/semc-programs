#! /usr/bin/perl -w
# script to eliminated micrographs completely where relion warns too few particles
# run in directory containine particles.star and run.out
# wjr 062617
#
my $logfile = 'run.err';
my $partfile = 'particles.star';
my $edited = 'particles_edited.star';

open (IN,$logfile) or die "cannot read $logfile\n";
while (<IN>) {
   if ($_ =~ m/Warning: .*\s(.*\.mrc)\./) {
      push @list,$1;
      print "match $1\n";
   }
}
close (IN);
open (IN,$partfile) or die "cannot open $partfile\n";
open (OUT,">$edited") or die "cannot write $edited\n";
while (<IN>) {
   @data = split (" ",$_);
   if ($#data<6) {
      print OUT $_;
      next;
   }
   else {
      $skip=0;
      foreach $bad (@list) {
         if ($_ =~ m/$bad/) {
            $skip=1;
            $deleted++;
            last;
         }
      }
      unless ($skip) {
         print OUT $_;
         $saved++;
      }
   }
}
my $badmic = $#list+1;
print "\nNumber of micrographs to eliminate: $badmic\n";
print "Eliminated $deleted paticles, saved $saved in file $edited\n";
 

