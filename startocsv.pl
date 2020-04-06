#! /usr/bin/perl -w
#
my @files=glob ("*.star");
my $file = $files[$#files];
print "star files available: ";
foreach my $file (@files) {
		print "$file\n";
	}
print "Enter star file, default $file\n";
chomp ( $infile=<STDIN>);
if ($infile) {$file=$infile;}
my $outfile=$file;
$outfile =~ s/star/csv/;

open (IN,$file) or die "no read $file\n";
open (OUT,">$outfile") or die "no write $outfile\n";
while (<IN>) {
	my @data = split (" ",$_);
	next unless $#data > 0;
	if ($data[$#data] =~ m/\#/ ) {
		$header=1;
		print OUT "$data[0] ";
	}
	else {
		s/-a/-a-DW/;
		if ($header >0) {$header=0; print OUT "\n";}
		print OUT ;
	}
}

