#! /usr/bin/perl -w

my $size=3600;
my $count=0;
print "Enter thickness file: ";
chomp (my $file=<STDIN>);
print "Enter minimum value: ";
chomp (my $min=<STDIN>);
print "Enter maximum value: ";
chomp (my $max = <STDIN>);
my $outfile = 'substack' . $max . '.hdf';
print "Enter output stack (default $outfile): ";
chomp (my $line=<STDIN>);
if ($line) {$outfile=$line;}
my $power = 'powerspectrum' . $max . '.hdf';
print "Enter powerspectrum (default $power): ";
chomp ($line=<STDIN>);
if ($line) {$power=$line;}
my $plt = 'pwplt' . $max . '.txt';
print "Enter 1D power plot (default $plt): ";
chomp ($line=<STDIN>);
if ($line) {$plt=$line;}
open (IN,$file) or die "cannot read $file\n";
while (<IN>) {
   my @data=split(" ",$_);
   my $filename = $data[1];
   my $mean = $data[3];
   if ($mean >= $min and $mean <= $max) {
      `e2proc2d.py --clip $size,$size $filename $outfile`;
      $count++;
   }
}
print "Stacked $count files into $outfile\n";
print "calculating power spectrum $power...\n";
`sxprocess.py $outfile $power --pw`;
print "calculating 1D power plot $plt...\n";
`sxprocess.py $outfile --rotpw=$plt`;

