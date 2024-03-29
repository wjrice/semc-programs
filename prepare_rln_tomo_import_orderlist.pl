#! /usr/bin/perl
# to make the required relion ordered list of collection file
# for relion 4.0
# wjr 01-03-2023
#
use warnings;
use strict;

my @files = glob("*.mdoc");
foreach my $file(@files) {
   my (@tiltangles,@doses,%tiltangle,%collectorder);
   my $outfile = $file;
   $outfile =~ s/mdoc/csv/;
   open (IN,$file) or die "cannot read $file\n";
   while (<IN>) {
      if (m/TiltAngle/) {
         my @data=split(" ",$_);
         push @tiltangles, pop @data;
      }
      elsif (m/PriorRecordDose/) {
         my @data=split(" ",$_);
         push @doses, pop @data;
      }
   }
   close (IN);
my $i=0;
   foreach my $dose (@doses) {
      $tiltangle{$dose} = $tiltangles[$i];
      $i++;
   }
   open (OUT,">$outfile") or die "cannot write $outfile\n";
   my @keys = sort {$a <=> $b} keys %tiltangle;
    $i=1;
   foreach my $dose (@keys) {
      print OUT "$i,$tiltangle{$dose}\n";
      $i++;
   }
   close OUT;
}
 
