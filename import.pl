#! /usr/bin/perl -w
#
# script to import a set of files one by one intot eman2
# importing all into eman2 at once seems to skip the 8 bit conversion, and also there does not seem to be a way to specify rawtlt files
# whr 5/30/21
#
#
#e2import.py warp/21may29_leica_tomo01.st --apix=1.408 --import_tiltseries --rawtlt=warp/21may29_leica_tomo01.rawtlt --compressbits=8 --importation=copy 
my $apix = 1.408;
if (defined $ARGV[0]) {
   $apix=$ARGV[0];
}
else { die "usage: import.pl <pixelsize in A>\n files should be in warp/ folder\n";}


my @files=glob("warp/*.st");
foreach my $file (@files) {
   my $rawtlt = $file;
   $rawtlt =~ s/st/rawtlt/;
   print "importing $file to eman2 using pixel size $apix\n";
   `e2import.py $file --apix=$apix --import_tiltseries --rawtlt=$rawtlt --compressbits=8 --importation=copy` ;
}

