#! /usr/bin/perl -w
#
#
my @files = glob("*.star");
my ($width,$height,$depth,$estwidth,$estheight,$conf,$numboxes,$angle) = (4,20,20,16,16,0.2,5,"<NA>");
my %header;
foreach my $file (@files) {
	open (IN,$file) or die "cannot read $file\n";
	my $outfile = $file;
	$outfile =~ s/star/cbox/;
	while (<IN>) {
		last if (m/loop_/);
	}
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


	print OUT <<eof;
data_global

_cbox_format_version 1.0

data_cryolo

loop_
_CoordinateX #1
_CoordinateY #2
_CoordinateZ #3
_Width #4
_Height #5
_Depth #6
_EstWidth #7
_EstHeight #8
_Confidence #9
_NumBoxes #10
_Angle #11
eof

	printf OUT "%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %s\n",($xcoord,$ycoord,$zcoord,$width,$height,$depth,$estwidth,$estheight,$conf,$numboxes,$angle);

	while (<IN>) {
		my @data = split(" ",$_);
		my $micname = $data[$header{'MicrographName'}];
		my $xcoord = $data[$header{'CoordinateX'}];
		my $ycoord = $data[$header{'CoordinateY'}];
		my $zcoord = $data[$header{'CoordinateZ'}];
		printf OUT "%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %s\n",($xcoord,$ycoord,$zcoord,$width,$height,$depth,$estwidth,$estheight,$conf,$numboxes,$angle);
	}
	close (IN);
	close (OUT);
}




