#! /usr/bin/perl -w
#
my @files = glob("*-a.???");
foreach my $file (@files) {
   my $newfile=$file;
   $newfile =~ s/esn-a/esn-a-DW/;
   #if (-e $newfile) {unlink $newfile;}
   next if (-e $newfile);
   `cp $file $newfile`;
}

