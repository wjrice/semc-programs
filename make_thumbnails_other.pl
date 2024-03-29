#! /usr/bin/perl -w
#
my $path = "/data/cryoem/cryoemdata/cache/";

my @files = glob("*sq.mrc");
$files[0] =~ m/(23jun\d\d\w)/;
my $session = $1;
$path .= $session . "/";
print "session $session path $path\n";
unless (-e $path) {`mkdir -p $path`;}

my @hlfiles = glob("*hl.mrc");
push (@files,@hlfiles);
foreach my $file (@files) {
   my $pngfile = $file;
   $pngfile = $path . $pngfile;
   $pngfile =~ s/mrc/png/;
   my $jpgfile = $pngfile;
   $jpgfile =~ s/png/jpg/;
   `e2proc2d.py $file $pngfile`;
   `convert -geometry 1024x768 $pngfile $jpgfile`;
   unlink $pngfile;
   unlink $file;
} 
@files=glob("*gr.mrc");
foreach my $file (@files) {
   my $pngfile = $file;
   $pngfile = $path . $pngfile;
   $pngfile =~ s/mrc/png/;
   my $jpgfile = $pngfile;
   $jpgfile =~ s/png/jpg/;
   `e2proc2d.py $file $pngfile`;
   `convert $pngfile $jpgfile`;
   unlink $pngfile;
} 
@files=glob("*e?n.mrc");
foreach my $file (@files) {
   my $pngfile = $file;
   $pngfile = $path . $pngfile;
   $pngfile =~ s/mrc/png/;
   my $jpgfile = $pngfile;
   $jpgfile =~ s/png/jpg/;
   `e2proc2d.py $file $pngfile`;
   `convert $pngfile $jpgfile`;
   unlink $pngfile;
   unlink $file;
} 

