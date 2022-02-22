#! /usr/bin/perl
# script to replace the original micrograph filename with the strange name created by cryosparc
# which has many random digits appended to the front of the filename
# inputs: directory lisitng from cryosparc input, 1 file per line, which has the new filenames with numbers appended
#         star file with originila filenames
# outputs: replaces original filenames in star file with cryosparc filenames
#          original star files saved as <starfile>.orig
# wjr 12-30-21
#
use strict;
use warnings;

unless ( $#ARGV > 0) {
   die "Usage: $0 <listing file> <star file to fix> \n";
}
my $listing = $ARGV[0];
my $star_in = $ARGV[1];
my $star_out =  $star_in . ".temp"; #$ARGV[2];

my %fixer;
my $micname_index;
open (IN,$listing) or die "cannot read $listing\n";
while (<IN>) {
   chomp;
   if ($_ =~ m/^\d+_(.*\.mrc)/) {
      my $realname = $1;
      $fixer{$realname} = $_;
   }
}
close (IN);

#my @keys = sort keys %fixer;
#foreach my $key (@keys) {
   #print "$key $fixer{$key}\n";
#}
      
open (IN,$star_in) or die "cannot read $star_in\n";
open (OUT,">$star_out") or die "cannot write $star_out\n";
while (<IN>) {
   if ($_ =~ m/mrc/) {
      my @data=split(" ",$_);
      my $mic_name = $data[$micname_index];
      my @data2 = split(/\//,$mic_name);
      $mic_name = pop @data2;
      if (defined $fixer{$mic_name}) {
         $data[$micname_index] = $fixer{$mic_name};
      }
      else {
         print "cannot find key $mic_name\n";
         print "That file is not in the directory listing. Quitting\n";
         die;
      }

      my $line = join (" ",@data);
      print OUT "$line\n";
   }
   else {
      print OUT;
      if ($_ =~ m/_rlnMicrographName\s+#(\d+)/) {
         $micname_index = $1 -1;
      }
   }
}
close (IN);
close (OUT);
rename ($star_in, "$star_in.orig") or die "Can't rename $star_in to $star_in.orig: $|";
rename ($star_out, $star_in) or die "Can't rename $star_out to $star_in: $|";
 
