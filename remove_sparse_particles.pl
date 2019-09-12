#! /usr/bin/perl -w

my $input = 'mic_ptcls.txt';
my $min=5;
my $output = 'cleaned_mic.txt';
my $line;

print "Enter input file, default $input: ";
chomp ($line=<STDIN>);
if ($line) {$input=$line;}
print "Enter minimum particles (default $min): ";
chomp ($line=<STDIN>);
if ($line) {$min=$line;}
print "Enter output (default $output): ";
chomp ($line=<STDIN>);
if ($line) {$output=$line;}
open (IN,$input) or die "cannot read $input\n";
open (OUT,">$output") or die "cannot write $output\n";
my $sum=0;
my $tot=0;
while (<IN>) {
   my @data = split(" ",$_);
   $num = pop @data;
   if ($num >= $min) {
      print OUT; 
      $tot++;
      $sum += $num;
   }
}
print "\nSaved $sum particles from $tot micrographs\n";
 
 

