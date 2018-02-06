#! /usr/bin/perl -w
use File::Copy qw(move);

#wjr 092217
# select good microgrpahs based on CTF Thon ring extent and ice thickness
# micrograph boxes should be in micrographs/allbox/
#it will choose bext Thon ring form minumim of appion and ctf-package
#edit
#-------------------------------------------------
$ctf_max = 4.5 ; #selection for max Thon ring extent
$thick_max = 50 ; #nm select max thickness allowed
$thick_file = "thickness_16sep21j.txt";  #thickness file data
#---------------------------------------------------
print "dat files:";
@files = glob ("*.dat");
foreach $file (@files) {print "$file\n";}
$file = $files[0];
open (IN,$file) or die "cannot read $file\n";
unless (-e "micrographs/micrographs") {mkdir "micrographs/micrographs";}
#print "Enter limit:";
#chomp ($ctf_max = <STDIN>);
<IN>;
while (<IN>) {
   @data=split(" ",$_);
   $imagename=$data[$#data];
   $ctf_pack = $data[9];
   $ctf_app = $data[8];
   $ctf_avg = $ctf_pack <= $ctf_app ? $ctf_pack : $ctf_app ; 
   $ctfdata{$imagename} = $ctf_avg
}
close ($file);

open (IN, "thickness_16sep21j.txt") or die "cannot read thickness\n";
while (<IN>) {
   @data = split(" ",$_);
   shift @data;
   $imagename = shift @data;
   shift @data;
   $thickness = shift @data;
   $thick{$imagename} = $thickness;
}

@keys = sort keys %thick;
foreach $key (@keys) {
   if ($ctfdata{$key} <$ctf_max and $thick{$key} <=$thick_max) {
      print "$key $ctfdata{$key} $thick{$key}\n";
      $boxname = $key . '-DW.box';
      move "micrographs/allbox/$boxname", "micrographs/micrographs/$boxname";
      $good++;
   }
}
close IN;

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
print "found $good good micrographs\n";
#now keep the good ctf-only no-thickness data
print "searching through $#ctfkeys micrographs with no thickness data\n";
foreach $key (@ctfkeys) {
   if ($ctfdata{$key} <$ctf_max ) {
      print "$key $ctfdata{$key} \n";
      $boxname = $key . '-DW.box';
      move "micrographs/allbox/$boxname", "micrographs/micrographs/$boxname";
      $good++;
   }
} 

print "found total of $good good micrographs\n";
