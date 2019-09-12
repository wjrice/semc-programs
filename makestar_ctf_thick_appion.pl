#! /usr/bin/perl -w
# script to make an edited star file from a downloaded star file
# select according to Thon ring max (best of Appion 50% or package) and thickness
# if no thickness data, select only according to Thon rings
# three files needed:
#    1 thickness file
#    2 ctf star file downloaded from Appion
#    3 best ctf dat file downloaded from Appion
# input star file and dat file should both refer to enn-a
# input thickness file can refer to jnk

#outputs: ctfdata_allgood.star
# replaces enn-a with enn-a-DW in output star file
#    -- also works for esn-a, enn-b, etc.

# wjr 11-5-17
# 03-01-18: modified for thickness data downloaded from appion

print "star files:\n";
@files = glob ("*.star");
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
print "txt files:\n";
@files = glob ("*.txt");
foreach $file (@files) {print "$file\n";}
print "input thickness file (default $files[0]): ";
chomp ($tfile=<STDIN>);
unless ($tfile) {$tfile = $files[0];} #if lazy
print "Enter max thickness limit in nm (default 50): ";
chomp ($maxtlimit = <STDIN>);
unless ($maxtlimit) {$maxtlimit = 50;} #if lazy
print "Enter min thickness limit in nm (default 0): ";
chomp ($mintlimit = <STDIN>);
unless ($mintlimit) {$mintlimit = 0;} #if lazy
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

# get correct extension
@keys = sort keys %ctfdata;
$testname = $keys[0];
$testname =~ m/.*(e[sn]n-[a-z].mrc)/;
$type = $1; # enn-a, esn-a, enn-b, ....
open (IN, $tfile) or die "cannot read $tfile\n";
<IN>; #skip first line
while (<IN>) {
   @data = split(" ",$_);
   next if ($#data < 2);
   shift @data;
   $imagename = shift @data;
   $imagename =~ s/e.n$/$type/;  #this should fix it
   $thickness = pop @data;
   $thick{$imagename} = $thickness;
}
close (IN);

open (IN,$starfile) or die "cannot read $starfile\n";
while (<IN>) {
   if ($_ =~ m/rlnPhaseShift/) {
      last;
   }
}
while (<IN>) {
   chomp $_;
   @data = split(" ",$_);
   @data1 = split(/\//,$data[0]);
   $stardata{$data1[1]} =$_;
   #print "$data1[1]\n";

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


@keys = sort keys %thick;
foreach $key (@keys) {
   if (not $ctfdata{$key}) {print "no ctfdata for $key\n";next;}
   if ($ctfdata{$key} <$ctflimit and $thick{$key} <=$maxtlimit and $thick{$key} >=$mintlimit) {
      #print "$key $ctfdata{$key} $thick{$key}\n";
      $stardata{$key} =~ s/e([sn])n-a/e$1n-a-DW/g;  # add DW flag to line
      print OUT "$stardata{$key} $ctfdata{$key}\n";
      $good++;
   }
}
print "found $good good micrographs by thickness and ctf\n";

# add data where no thickness available
@ctfkeys = sort keys %ctfdata;
foreach $name (@keys) {
  for ($i=0; $i <= $#ctfkeys; $i++) {
      if ($name eq $ctfkeys[$i]) {
         splice @ctfkeys, $i, 1; #delete this item from list
         last;
      }
   }
}
#now keep the good ctf-only no-thickness data
print "searching through $#ctfkeys micrographs with no thickness data available\n";
foreach $key (@ctfkeys) {
   if ($ctfdata{$key} <$ctflimit ) {
      $stardata{$key} =~ s/e([ns])n-([a-z])/e$1n-$2-DW/g;  # add DW flag to line
      print OUT "$stardata{$key} $ctfdata{$key}\n";
      $good++;
   }
} 

print "found total of $good good micrographs\n";
