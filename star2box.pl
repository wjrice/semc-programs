#! /usr/bin/perl -w
#
# simple script to make an EMAN/EMAN2 style box file from a star file
# one file or all files
#

my $input;
if ($ARGV[0]) {
   $input=$ARGV[0];
}
else {
   print "Enter file to convert, or ALL for all star files: ";
   chomp ($input=<STDIN>);
}
my @files;
if ($input eq 'ALL') {
   @files = glob("*.star");
}
else {
   push @files,$input;
}

my %header;
foreach my $file (@files) {
        my $numloops = `grep loop $file | wc -l`;
        my $countloop = 0;
	open (IN,$file) or die "cannot read $file\n";
        while ($countloop < $numloops) {
            my $line=<IN>;
            if ($line =~ m/loop/) {
                $countloop++;
            }
	}
	my $outfile = $file;
	$outfile =~ s/star/box/;
	my $line = <IN>;
	while ( $line =~ m/_rln(\w+)\s\#(\d+)/) {
		my $type=$1;
   		my $itemnum=$2;
   		$header{$type} = $itemnum -1 ; #array numbers start at 0 while relion starts at 1
   		chomp $line; 
   		$line = <IN>;
	}
	my @keys = sort keys (%header);
	print "@keys\n";
	foreach my $key (@keys) {
		print "$key $header{$key}\n";
	}


	my @data = split(" ",$line);
	my $micname = $data[$header{'MicrographName'}];
	my $xcoord = $data[$header{'CoordinateX'}];
	my $ycoord = $data[$header{'CoordinateY'}];
	my $zcoord = $data[$header{'CoordinateZ'}];
	open (OUT,">$outfile") or die "cannot write $outfile\n";
	print "$data[$header{'CoordinateX'}] $data[$header{'CoordinateY'}] $data[$header{'CoordinateZ'}] \n";
	print "$header{'CoordinateX'} $header{'CoordinateY'} $header{'CoordinateZ'} \n";


	printf OUT "%f %f %f \n",($xcoord,$ycoord,$zcoord);

	while (<IN>) {
		my @data = split(" ",$_);
		next if ($#data<2);
		my $micname = $data[$header{'MicrographName'}];
		my $xcoord = $data[$header{'CoordinateX'}];
		my $ycoord = $data[$header{'CoordinateY'}];
		my $zcoord = $data[$header{'CoordinateZ'}];
	printf OUT "%f %f %f \n",($xcoord,$ycoord,$zcoord);
	}
	close (IN);
	close (OUT);
}




