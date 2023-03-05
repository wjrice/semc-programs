#! /usr/bin/perl -w
# particles by ice thickness
# assumes that particles by micrograph script was already run, and that a file of Leginon ice thickness
# values is available
# file made by particles_by_micrograph.pl is called mic_ptcls.txt
# The script will fix files here to match the ice thickness table from Leginon website, which should be NNNNesn.mrc,
# not NNNNesn-a-DW.mrc or NNNNesn_frames.mrc
# wjr 12-19-22

my $part_file = 'mic_ptcls.txt';
my $ice_file;
my $fileout = "thickness_particle.txt";
if ($ARGV[0]) {
   $ice_file = $ARGV[0];
}
else {
   print "Enter filename for ice thickness: ";
   chomp ($ice_file = <STDIN>);
}
my %particles;
open (IN,$part_file) or die "cannot read $part_file\n";
while (<IN>) {
   next unless (m/mrc/);
   my @data = split(" ",$_);
   my $particles = pop @data;
   my $name = pop @data;
   @data = split(/\//,$name);
   $name = pop @data;
   $name =~ s/_frames//;
   $name =~ s/-a-DW//;
   $particles{$name} = $particles;
   #print "$name\n";
}
close (IN);

my %sum;
open (IN,$ice_file) or die "cannot read $ice_file\n";
my $line=0;
while (<IN>) {
   next unless (m/mrc/);
   $line++;
   my @data = split(" ",$_);
   my $thickness = pop @data;
   my $filename = $data[1];
   $thickness = int($thickness/10) * 10;
   #print "line $line  thickness = $thickness\n";
   unless (defined ($sum{$thickness})) {
      $sum{$thickness}=0;
    #  print "reset for $thickness on line $line\n"
   }
   if (defined $particles{$filename}) {
      $sum{$thickness} += $particles{$filename};
      #print "added $particles{$filename} from $filename to  thickness $thickness making sum $sum{$thickness}\n";
   }
   else {
      #print "no particles in $filename\n";
   }
}
close (IN);

my @keys = sort {$a <=> $b} keys %sum;
#foreach $key (@keys) { 
#   print "this is a key in sum: $key\n";
#}

open (OUT,">$fileout") or die "cannot write $fileout\n";
print OUT "Thickness (nm)    Number of particles\n";
foreach my $key (@keys) {
#   print "$key\n";
   if (defined ($sum{$key})) {
      print OUT "$key $sum{$key}\n";
   }
   else {
      print "not defined $key\n";
   }
}
close (OUT);

print "Wrote thickness results to $fileout\n";
 

