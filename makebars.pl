#! /usr/bin/perl -w
# needs IMOD environment loaded to work
my @files = glob("*e?n-?.mrc");
#my @files = glob("*.mrc");
my $mydir = "scalebar";
my $set=0;

unless (-e $mydir) {mkdir $mydir;}
`ln -s ../mrc2jpg_withscale.py .`;
`ln -s ../MrcImagePlugin.py .`;
if ($ARGV[0]) {
   $apix = $ARGV[0];
   $set=1;
}
foreach $file (@files) {
unless ($set) {
      $line = `header $file | grep Angstroms`;
      @data = split(" ",$line);
      $apix = pop (@data);
}
   $fileout = $file;
   $fileout =~ s/mrc/png/;
   print "$file $apix\n";
   `./mrc2jpg_withscale.py $file $mydir/$fileout $apix`;
}


