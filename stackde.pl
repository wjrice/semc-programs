#! /usr/bin/perl -w
#script to stack DE frames into one mrc stack
#note: dose correction not done -- these are still raw frames
#frames are stored as 12-bit INTs , so use -s option (signed) to store as MRC mode 1 (signed int)
#needs IMOD tools in path
#run in root rawdata directory where all the .frames directories exist
#wjr 09-17-17
#
my @dirs = glob("*.frames");
foreach $dir (@dirs) {
   print "working on $dir\n";
   chdir $dir;
   my @digitfiles = glob ("RawImage_?.tif"); #need to make all files have 2-digit numbering for sort order to be correct
   foreach $file (@digitfiles) {
      my $newfile = $file;
      $newfile =~ s/RawImage_/RawImage_0/;
      rename $file,$newfile;
   }
   my $stackname = "../" . $dir . ".mrc";
   `tif2mrc -s *.tif $stackname`; #IMOD program to stack: -s option means treat input as signed INT
   chdir "../"; #go back up
}

