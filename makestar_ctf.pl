#! /usr/bin/perl -w
# script to make an edited star file from a downloaded star file
# select according to Thon ring max (best of Appion 50% or package)
# 
# two files needed:
#    1 ctf star file downloaded from Appion
#    2 best ctf dat file downloaded from Appion
# input star file and dat file should both refer to enn-a

#outputs: ctfdata_allgood.star
# replaces enn-a with enn-a-DW in output star file
#    -- also works for esn-a, enn-b, etc.

# wjr 11-5-17

print "star files:\n";
@files = glob ("micrographs*.star");
foreach $file (@files) {print "$file\n";}
print "Enter current ctf star file (default $files[0]): ";
chomp ($starfile = <STDIN>);
unless ($starfile) {$starfile = $files[0];} #if lazy

print "dat files:\n";
@files = glob ("*.dat");
foreach $file (@files) {print "$file\n";}
print "input ctf data file (default $files[0]): ";
chomp ($datfile=<STDIN>);
unless ($datfile) {$datfile = $files[0];} #if lazy

print "Enter Thon ring limit in A (default 4.5): ";
chomp ($ctflimit = <STDIN>);
unless ($ctflimit) {$ctflimit = 4.5;} #if lazy

open (IN,$datfile) or die "cannot read $datfile\n";
<IN>; #skip first line of .dat file
while (<IN>) {
   @data=split(" ",$_);
   $imagename=$data[$#data];
   $imagename .= '.mrc' ;  #need to add extension
   $ctf_pack = $data[9];
   $ctf_app = $data[8];
   $ctf_avg = $ctf_pack <= $ctf_app ? $ctf_pack : $ctf_app ; #chooses lowest value
   if ($ctf_app == 0) {$ctf_avg = $ctf_pack;}
   $ctfdata{$imagename} = $ctf_avg
}
close (IN);

open (IN,$starfile) or die "cannot read $starfile\n";
while (<IN>) {
   if ($_ =~ m/rlnPhaseShift/) {
      last;
   }
}
my %stardata;
while (<IN>) {
   chomp $_;
   @data = split(" ",$_);
   @data1 = split(/\//,$data[0]);
   my $filename = pop @data1;
   $stardata{$filename} =$_;
#   print "$filename\n";

}
close (IN);

my $outfile = 'ctfdata_allgood.star';
open (OUT,">$outfile") or die "cannot write\n";
my $header = <<"END_HEADER"; 

data_

loop_
_rlnMicrographName #1
_rlnCtfImage #2
_rlnDefocusU #3
_rlnDefocusV #4
_rlnDefocusAngle #5
_rlnVoltage #6
_rlnSphericalAberration #7
_rlnAmplitudeContrast #8
_rlnMagnification #9
_rlnDetectorPixelSize #10
_rlnCtfFigureOfMerit #11
_rlnPhaseShift #12
_rlnCtfMaxResolution #13
END_HEADER

print OUT $header;


#now keep the good ctf-only no-thickness data
@ctfkeys = sort keys %ctfdata;
my $ctfmean=0;
print "searching through $#ctfkeys micrographs with no thickness data available\n";
foreach $key (@ctfkeys) {
   if ($ctfdata{$key} <$ctflimit ) {
      $stardata{$key} =~ s/e([ns])n-([a-z])/e$1n-$2-DW/g;  # add DW flag to line
      print OUT "$stardata{$key} $ctfdata{$key}\n";
      $good++;
      $ctfmean += $ctfdata{$key};
   }
} 

print "found total of $good good micrographs\n";
$ctfmean /= $good;
printf ("Mean Thon ring extent = %4.2f \n",$ctfmean);

