#! /usr/bin/perl -w
#
#alignframes -bin 4,1 -vary 0.05 -gpu 2 -mdoc tomo_pt43.st.mdoc -path frames -gain frames/SuperRef_virus_0001.mrc -binning 4,2 tomo_pt43_ali.st
#
my @files = glob ("*.mdoc");
foreach $file (@files) {
   $outfile = $file;
   $outfile =~ s/\.st\.mdoc/_ali.st/;
   print "alignframes -bin 4,1 -vary 0.05 -gpu 1 -mdoc $file -path frames -gain frames/SuperRef_virus_0001.mrc -binning 4,2 $outfile\n";
   `alignframes -bin 4,1 -vary 0.05 -gpu 1 -mdoc $file -path frames -gain frames/SuperRef_virus_0001.mrc -binning 4,2 $outfile`;
}

