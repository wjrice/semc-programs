#! /usr/bin/perl -w
#
# to copy arctica k3 serialEM data to gpfs
# wjr 06-07-23
#
unless (defined $ARGV[0]) {
   die "Usage: $0 <Leginon session> \nExample: $0 23jun07a \n"; 
}
my $session=$ARGV[0];

while (1) {
   print "Copying frames and mdoc files from arctica k3 to gpfs for session $session\n";
   unless (-e "/gpfs/data/cryoem/cryoemdata/appion/${session}/serialem/frames") {
      `mkdir -p "/gpfs/data/cryoem/cryoemdata/appion/${session}/serialem/frames"`; 
   }
   my $mdoccopy = `rsync -ar --progress /arcticak3/SerialEM_frames/${session}*tomo*.st.mdoc /gpfs/data/cryoem/cryoemdata/appion/${session}/serialem/.`;
   my $tiffcopy = `rsync -ar --progress /arcticak3/SerialEM_frames/${session}_frames/* /gpfs/data/cryoem/cryoemdata/appion/${session}/serialem/frames/.`; 
   if ($mdoccopy =~ m/xfr#/) {
      print "New mdoc files were copied in last iteration\n";
   }
   else {
      print "No new mdoc files were copied in last iteration\n";
   }
   if ($tiffcopy =~ m/xfr#/) {
      print "New tiff frames were copied in last iteration\n";
   }
   else {
      print "No new tiff frames were copied in last iteration\n";
   }
   print "\n";
   sleep 100; 
}
