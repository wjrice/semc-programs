#! /usr/bin/perl -w
# purpose: make a more_manual_coarse .tlt file from original coarse .tlt file
#          Uses the initial alignment from etomo alignment to make the moremanual coarse alignment file 
#          this may work better for tilt series with large shifts, when protomo is annoying
#          Workflow in this case:
#              cd to stack directory
#              etomo
#              can skip xray correction
#              do prealignment, with advanced output set to binning 1
#              alignment params are in {tubename}.prexg  (this has the 0-degree tilt image with minimal translation)
#              copy this file to protomo tilt directory
#             
#             imod_to_protomo_coarse.pl  -- will make a new more_manual_coarse .tlt file using the .prexg file
#          
#   wjr 12202017

my @files=glob("coarse*.tlt");
my $base;
unless (@files) {die "No .tlt files found in current directory.\n";}
if ($#files>0) {# cannot tell which tlt file to use, so ask
   print "Enter name of tlt file to fix (including extension): ";
   chomp ($base=<STDIN>);
}
else {
   $base=$files[0];
}


my @list=split (/\./,$base);
my $fileout = 'more_manual_' . $base;
open (OUT,">$fileout") or die ("Cannot write to output file $fileout\n");

print "Enter size of images:";
chomp (my $imagesize=<STDIN>);
my $center = $imagesize/2;

my $log10=log(10);
my @imod_param_files = glob("*.prexg");
if ($#imod_param_files>0) {print "warning: more than one imod param file found. using $imod_param_files[0]\n";}
my $imod_param_file = shift (@imod_param_files);
unless (-e $imod_param_file) {
   print "Cannot find imod .prexg file. Enter path and filename for this file: ";
   chomp ($imod_param_file = <STDIN>);
}
open (IN,$imod_param_file) or die "cannot open file $imod_param_file for reading\n";
while (<IN>) {
   @imod_data=split(" ",$_);
   push @xshift,$imod_data[4];
   push @yshift,$imod_data[5];
}
close (IN);

open (IN,$base) or die ("Cannot read file $base\n");
my $i=0;
while (<IN>) {
    if ($_ =~ /ORIGIN/) {
        my $xshift = shift(@xshift);
        my $yshift = shift (@yshift);
        my $xcen = $center - $xshift;
        my $ycen = $center - $yshift;  
        $k = $i +1;
        my $space = ($k<10? ' ' :'');
	$j=int(log($k+0.1)/$log10 + 2); #number of spaces needed for digit	
	printf OUT ("   IMAGE%${j}d %s   ORIGIN  [ %8.3f  %8.3f ]\n",$k,$space,$xcen,$ycen);
        $i++;
      }
     else {
         print OUT $_;
     }
}

close (IN);
close (OUT);

