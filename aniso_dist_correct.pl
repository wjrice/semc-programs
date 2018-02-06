#! /usr/bin/perl -w
#The following distortion parameters were found :-
#
#Distortion Angle     = 36.4
#Major Scale          = 1.004
#Minor Scale          = 0.996
#
# Stretch only parameters would be as follows :-
#
# Distortion Angle     = 36.4
# Major Scale          = 1.008
# Minor Scale          = 1.000
# Corrected Pixel Size = 1.066
#
# The Total Distortion = .80%
#
my $prog = '/emg/sw/mag_distortion_correct_1.0.0/bin/mag_distortion_correct_openmp_8_18_15.exe';
my $ang=36.4;
my $major=1.004;
my $minor=0.996;
my $subdir = "corrected/";
my @files=glob("*esn-a*.mrc");

foreach $file (@files) {
   print "working on $file\n";
   open (OUT,">tmp.txt") or die "cannot write tmp.txt\n";
   print OUT "$file\n";
   print OUT $subdir . $file . "\n";
   print OUT "$ang\n";
   print OUT "$major\n";
   print OUT "$minor\n";
   print OUT "no\n";
   print OUT "no\n";
#   print OUT "\n\n";
   close (OUT);
   
   `$prog <tmp.txt`;
}

