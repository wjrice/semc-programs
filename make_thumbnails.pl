#! /usr/bin/perl -w
#
my @files = glob("*e?n-a.mrc");
my $path = "/data/cryoem/cryoemdata/cache/";
$files[0] =~ m/(23jun\d\d\w)/;
my $session = $1;
$path .= $session . "/";
print "session $session path $path\n";
unless (-e $path) {`mkdir -p $path`;}

foreach my $file (@files) {
   my $pngfile = $file;
   $pngfile = $path . $pngfile;
   $pngfile =~ s/mrc/png/;
   my $jpgfile = $pngfile;
   $jpgfile =~ s/png/jpg/;
   my $dwfile = $jpgfile;
   $dwfile =~ s/(e\wn-a)/$1-DW/;
   unless (-e $jpgfile) {
       `e2proc2d.py --fouriershrink=4 $file $pngfile`;
       `convert -geometry 1024x768 $pngfile $jpgfile`;
       unlink $pngfile;
   }
   next if (-e $dwfile);
   `cp $jpgfile $dwfile`;
}
 
