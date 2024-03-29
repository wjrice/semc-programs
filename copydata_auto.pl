#! /usr/bin/perl -w
# program to copy frames, aligned DW images, and warp particles to hpc
# designed for smart leginon
# goes through entire list of specified sessions once
# wjr 05-01-23
#

unless (defined $ARGV[1]) {
   die "Usage: $0 <Leginon session base> <letters> <destination in hpc/cryoem_data/\n Example: $0 22jun10 b-k cryoemlab\n"; 
}
my $sessionbase = $ARGV[0];
my $range = $ARGV[1];
my $dir = $ARGV[2];

my @subranges = split/,/,$range; #split on comma
my @sesletters;

foreach my $subrange (@subranges) {
   my ($beg,$end) = split("-",$subrange);
   push @sessionletters,($end? $beg .. $end : $beg);
}

foreach my $let (@sessionletters) {
   my $session = $sessionbase . $let; 
   unless (-e "/hpc/cryoem_data/$dir/$session") {
      `mkdir -p /hpc/cryoem_data/$dir/$session/frames`;
      `mkdir -p /hpc/cryoem_data/$dir/$session/aligned`;
      `mkdir -p /hpc/cryoem_data/$dir/$session/processed`;
   }

   print "copying frames for session $session to /hpc/cryoem_data/$dir/$session\n";
   my $frameout = `rsync -ar --progress /data/cryoem/cryoemdata/frames/$session/rawdata/* bigpurple-dm.nyumc.org:/gpfs/data/cryoem_data/$dir/$session/frames/.`;
   if ($frameout =~ m/xfr#/) {
      print "New frames were copied in the last iteration\n";
   }
   else {
      print "No new frames were copied in the last iteration\n";
   }
   print "copying aligned images for session $session to /hpc/cryoem_data/$dir/$session\n";
   my $alout = `rsync -ar --progress /data/cryoem/cryoemdata/leginon/$session/rawdata/*DW.mrc bigpurple-dm.nyumc.org:/gpfs/data/cryoem_data/$dir/$session/aligned/.`;
   if ($alout =~ m/xfr#/) {
      print "New aligned images were copied in the last iteration\n";
   }
   else {
      print "No new aligned images were copied in the last iteration\n";
   }
   if (-e "/data/cryoem/cryoemdata/appion/$session/warp") {
      print "copying warp for session $session to /hpc/cryoem_data/$dir/$session\n";
      my $warpout = `rsync -ar --progress /data/cryoem/cryoemdata/appion/$session/warp bigpurple-dm.nyumc.org:/gpfs/data/cryoem_data/$dir/$session/processed/.`;
      if ($warpout =~ m/xfr#/) {
         print "New warp images were copied in the last iteration\n";
      }
      else {
         print "No new warp images were copied in the last iteration\n";
      }
   }
   print "\n";
}
 
 
