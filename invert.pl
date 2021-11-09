#! /usr/bin/perl -w
my @files=glob("*.rawtlt");
foreach my $file (@files) {
   open (IN,$file) or die "no read $file\n";
   my $fileout = $file . '.fix';
   open (OUT,">$fileout") or die "no write $fileout\n";
   while (<IN>) {
      $_ *= -1;
      print OUT "$_\n";
   }
   close IN;
   close OUT;
}

