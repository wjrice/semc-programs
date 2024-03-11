#! /usr/bin/perl -w
# program to copy frames, aligned DW images, and warp particles to hpc
# runs a continuous rsync
# wjr 06-10-22
#

unless (defined $ARGV[1]) {
   die "Usage: $0 <Leginon session> <destination in hpc/cryoem_data/\n Example: $0 22jun10b cryoemlab\n"; 
}
my $session = $ARGV[0];
my $dir = $ARGV[1];

unless (-e "/hpc/cryoem_data/$dir/$session") {
   `mkdir -p /hpc/cryoem_data/$dir/$session/frames`;
   `mkdir -p /hpc/cryoem_data/$dir/$session/aligned`;
   `mkdir -p /hpc/cryoem_data/$dir/$session/processed`;
}

while (1) {
   print "copying frames for session $session to /hpc/cryoem_data/$dir/$session\n";
   #my $frameout = `rsync -ar --progress /data/cryoem/cryoemdata/frames/$session/rawdata/* bigpurple-dm.nyumc.org:/gpfs/data/cryoem_data/$dir/$session/frames/.`;
   my $frameout = `rsync -ar --progress /data/cryoem/cryoemdata/frames/$session/rawdata/* /hpc/cryoem_data/$dir/$session/frames/.`;
   if ($frameout =~ m/xfr#/) {
      print "New frames were copied in the last iteration\n";
   }
   else {
      print "No new frames were copied in the last iteration\n";
   }
   print "copying aligned images for session $session to /hpc/cryoem_data/$dir/$session\n";
   #my $alout = `rsync -ar --progress /data/cryoem/cryoemdata/leginon/$session/rawdata/*DW.mrc bigpurple-dm.nyumc.org:/gpfs/data/cryoem_data/$dir/$session/aligned/.`;
   my $alout = `rsync -ar --progress /data/cryoem/cryoemdata/leginon/$session/rawdata/*DW.mrc /hpc/cryoem_data/$dir/$session/aligned/.`;
   if ($alout =~ m/xfr#/) {
      print "New aligned images were copied in the last iteration\n";
   }
   else {
      print "No new aligned images were copied in the last iteration\n";
   }
   if (-e "/data/cryoem/cryoemdata/appion/$session/warp") {
      print "copying warp for session $session to /hpc/cryoem_data/$dir/$session\n";
      #my $warpout = `rsync -ar --progress /data/cryoem/cryoemdata/appion/$session/warp bigpurple-dm.nyumc.org:/gpfs/data/cryoem_data/$dir/$session/processed/.`;
      my $warpout = `rsync -ar --progress /data/cryoem/cryoemdata/appion/$session/warp /hpc/cryoem_data/$dir/$session/processed/.`;
      if ($warpout =~ m/xfr#/) {
         print "New warp images were copied in the last iteration\n";
      }
      else {
         print "No new warp images were copied in the last iteration\n";
      }
   }
   print "\n";
   sleep 30;
}
 
 
