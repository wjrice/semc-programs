#! /usr/bin/perl -w

my $thickness_file = 'tiger_thickness.txt';
my $zlp_file = 'tiger_zlp.txt';

my %intensity;
my %als;
my %zlp;
my %vac;
my %timestamp;
open (IN,$thickness_file) or die "no read $thickness_file\n";
while (<IN>) {
   next unless (m/mrc/);
   my @data = split(" ",$_);
   my $file = $data[1];
   $intensity{$file} = $data[4];
   $als{$file} = $data[2];
   $vac{$file} = $data[3];
   $timestamp{$file} = $data[0];
}
close (IN);

open (IN,$zlp_file) or die "no read $zlp_file\n";
while (<IN>) {
   next unless (m/mrc/);
   my @data = split(" ",$_);
   my $file = $data[1];
   $zlp{$file} = pop @data;
}
close IN;

my @keys = sort keys (%zlp);
foreach my $file (@keys) {
   my $I0 = $intensity{$file} * exp($zlp{$file} / $als{$file});
   my $relative = 100 * $I0 / $vac{$file};
   printf ("%s %i  %.2f\n",$file,$timestamp{$file},$relative);
}
 

