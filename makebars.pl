#! /usr/bin/perl -w
# needs IMOD environment loaded to work
my @files = glob("*.mrc");
my $mydir = "scalebar";
unless (-e $mydir) {mkdir $mydir;}
`ln -s ../mrc2jpg_withscale.py .`;
`ln -s ../MrcImagePlugin.py .`;

foreach $file (@files) {
   $line = `header $file | grep Angstroms`;
   $fileout = $file;
   $fileout =~ s/mrc/png/;
   @data = split(" ",$line);
   $apix = pop (@data);
   print "$file $apix\n";
   `./mrc2jpg_withscale.py $file $mydir/$fileout $apix`;
}


