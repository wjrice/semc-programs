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
   `rsync -ar --progress /data/cryoem/cryoemdata/frames/$session/rawdata/* /hpc/cryoem_data/$dir/$session/frames/.`;
   `rsync -ar --progress /data/cryoem/cryoemdata/leginon/$session/rawdata/*DW.mrc /hpc/cryoem_data/$dir/$session/aligned/.`;
   print "copying frames, aligned for session $session to /hpc/cryoem_data/$dir/$session\n";
   if (-e "/data/cryoem/cryoemdata/appion/$session/warp") {
      `rsync -ar --progress /data/cryoem/cryoemdata/appion/$session/warp /hpc/cryoem_data/$dir/$session/processed/.`;
      print "copying warp for session $session to /hpc/cryoem_data/$dir/$session\n";
   }
   sleep 300;
}
 
 
