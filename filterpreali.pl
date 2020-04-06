#! /usr/bin/perl -w
# to apply median filter to prealigned seriaem stack, used befoere generating fiducial model
# renames current prealigned stack to <>.preali.orig
#
#my @test = `ls *.preali`;
#print @test;
#my @test2=glob("*.preali");
#print @test2;
my @files=glob("*.preali");
print "files:\n";
#print @files;
#print "\ngfgg\n";
#print "$#files \n";
if ($files[0]) {
   $files[0] =~ m/^(.*)\.preali/;
   $basename=$1;
   print "filtering $files[0] round 1\n";
   `clip median -2d ${basename}.preali ${basename}_m1.preali`;
   print "filtering $files[0] round 2\n";
   `clip median -2d ${basename}_m1.preali ${basename}_m2.preali`;
   print "filtering $files[0] round 3\n";
   `clip median -2d ${basename}_m2.preali ${basename}_m3.preali`;
   rename "${basename}.preali" ,"${basename}.preali.orig";
   symlink "${basename}_m3.preali" ,  "${basename}.preali";
   print "Replaced original file $files[0] with 3 rounds of median filtering\n";
}
elsif ($#files >0 ) {
   print "Error! More than one preali file found:\n";
   foreach $file (@files) {print "$file\n";}
}
else {
   print "Error: can't find any .preali files\n";
}
 

