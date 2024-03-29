#! /usr/bin/perl -w
#
my @files = glob("*e?n-a.mrc");
my $path = "/data/cryoem/cryoemdata/cache/";
unless ($files[0] =~ m/(23jun\d\d\w)/) {die "issue matching session with $files[0]\n";}
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
   next if (-e $jpgfile);
   `e2proc2d.py --fouriershrink=4 $file $pngfile`;
   `convert -geometry 1024x768 $pngfile $jpgfile`;
   unlink $pngfile;
}
@files = glob("*e?n-a-DW.mrc");
foreach my $file (@files) {
   my $pngfile = $file;
   $pngfile = $path . $pngfile;
   $pngfile =~ s/mrc/png/;
   my $jpgfile = $pngfile;
   $jpgfile =~ s/png/jpg/;
   next if (-e $jpgfile);
   `e2proc2d.py --fouriershrink=4 $file $pngfile`;
   `convert -geometry 1024x768 $pngfile $jpgfile`;
   unlink $pngfile;
   unlink $file;
} 
@files = glob("*sq.mrc");
my @sqextra = glob("*sq_v??.mrc");
my @hlfiles = glob("*hl.mrc");
push (@files,@hlfiles);
push (@files,@sqextra);
foreach my $file (@files) {
   my $pngfile = $file;
   $pngfile = $path . $pngfile;
   $pngfile =~ s/mrc/png/;
   my $jpgfile = $pngfile;
   $jpgfile =~ s/png/jpg/;
   next if (-e $jpgfile);
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
   next if (-e $jpgfile);
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

