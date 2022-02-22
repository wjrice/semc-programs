#! /usr/bin/perl -w
# used to make a plot to track intensity changes over time
# needs ZLP and ALS thickness data, uses ZLP as "gold standard" to check ALS values
# output columns: filename unix_timestamp relative_intensity
# wjr 10 Nov 2021

unless ($#ARGV >0) {die "Usage: back_calc_intensity.pl <ALS_datafile.txt> <ZLP_datafile.txt> <OPTIONAL output_file.txt>\n";}
my $thickness_file = $ARGV[0];
my $zlp_file =$ARGV[1];
my $outfile;
if ($#ARGV >1) {
   $outfile=$ARGV[2];
}

my %intensity;
my %als;
my %zlp;
my %vac;
my %timestamp;
open (IN,$thickness_file) or die "cannot read $thickness_file\n";
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

open (IN,$zlp_file) or die "cannot read $zlp_file\n";
while (<IN>) {
   my @data = split(" ",$_);
   next unless ($data[0] =~ m/\d+/) ; 
   my $file = $data[1];
   $file .= '.mrc';  # zlp data has no mrc in filename, add it back here
   $zlp{$file} = pop @data;
}
close IN;

my @keys = sort keys (%zlp);
if (defined $outfile) {
   open (OUT,">$outfile") or die "cannot write $outfile\n";
}
foreach my $file (@keys) {
   next unless ($als{$file}>0) ;
   my $I0 = $intensity{$file} * exp($zlp{$file} / $als{$file});
   my $relative = 100 * $I0 / $vac{$file};
   if (defined $outfile) {
      printf OUT ("%s %i  %.2f\n",$file,$timestamp{$file},$relative);
   }
   else {
      printf ("%s %i  %.2f\n",$file,$timestamp{$file},$relative);
   }

}
close (OUT);

