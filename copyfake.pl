#! /usr/bin/perl -w
# to copy a set of esn-a files to DW, in case the original DW files were deleted
my @files = glob("*esn-a.jpg");
foreach my $file (@files) {
   my $dwfile = $file;
   $dwfile =~ s/esn-a/esn-a-DW/;
   unless (-e $dwfile) {
      `cp $file $dwfile`;
   }
}

