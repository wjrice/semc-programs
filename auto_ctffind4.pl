#! /usr/bin/perl -w
use strict;
#
# hard coded constants
my $command = "ctffind4 -j 24";  # 24 cpu mpi
my $cs = 2.7;
my $q0 = 0.07;
my $minres = 30;
my $maxres = 5;
my $dfstep = 100;
my $size=512;

print "Enter pixel size: ";
chomp (my $pixel=<STDIN>);
print "Enter voltage: " ;
chomp (my $voltage=<STDIN>);
print "Enter minimum defocus (A): ";
chomp (my $mindf=<STDIN>);
print "Enter maximum deficus (A): ";
chomp (my $maxdf=<STDIN>);

my @dirs = glob("*");
foreach my $dir (@dirs) {
   next unless (-d $dir);  # skip non-directories
   print "wroking on $dir\n";
   chdir $dir;
   unless (-e "$dir.st") {
      chdir "../";
      next;
   }
   unless (-e "$dir.mrc") {
      `ln -s $dir.st $dir.mrc`;
   }
   open (OUT,">tmp.txt") or die "cannot write to tmp.txt\n";
   print OUT "$dir.mrc\n";
   print OUT "no\n";
   print OUT "${dir}_output.mrc\n";
   print OUT "$pixel\n";
   print OUT "$voltage\n";
   print OUT "$cs\n";
   print OUT "$q0\n";
   print OUT "$size\n";
   print OUT "$minres\n";
   print OUT "$maxres\n";
   print OUT "$mindf\n";
   print OUT "$maxdf\n";
   print OUT "$dfstep\n";
   print OUT <<eof;
no
no
no
no
no
eof
   close (OUT);
   `$command < tmp.txt`;
   # rm `tmp.txt';
#   `mv diag
   chdir "../";
}

