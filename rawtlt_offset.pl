#! /usr/bin/perl -w
#
my @files = glob("*rawtlt");
unless (defined $ARGV[0]) {
   die "usage: rawtlt_adjust <offset>\n";
}
my $offset = $ARGV[0];
foreach my $file (@files) {
   my $fileout = $file . '.tmp';
   open (IN,$file) or die "cannot read $file\n";
   open (OUT,">$fileout") or die "cannot write $fileout\n";
   while (<IN>) {
      $_ -= $offset;
      print OUT "$_\n";
   }
   close (IN);
   close (OUT);
   rename $file, $file. ".orig";
   rename $fileout, $file;
}

