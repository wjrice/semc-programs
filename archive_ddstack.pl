#! /usr/bin/perl -w
#
my @dirs = glob("22??????");
foreach my $dir (@dirs) {
   print "working on $dir\n";
   if (-e "/data/cryoem/cryoemdata/appion/$dir/ddstack/ddstack1") {
      chdir  "/data/cryoem/cryoemdata/appion/$dir/ddstack/ddstack1";
      `zip -m logfiles.zip *.txt`;
      my @files=glob("dark*mrc");
      foreach my $file(@files) {unlink $file;}
      @files=glob("norm*mrc");
      foreach my $file(@files) {unlink $file;}
      #chdir "../../";
   }
   else {
      print "not exist $dir/ddstack/ddstack1\n";
   }
}

