#! /usr/bin/perl -w
#
my @use = `qstat -a`;
foreach $line(@use) {
 #  print "line $line" ;
   if ($line =~ m/SEMC-head.cm.cl/) {
      @data=split(" ",$line);
      $queue=$data[2];
      next unless $queue;
      $nodes = $data[5];
      $cpus = $data[6];
      $state = $data[9];
      if ($state =~ /R/) {
         $cpus_used{$queue} += $cpus;
         $nodes_used{$queue} += $nodes;
      }
   }
}
foreach $queue (sort keys %nodes_used) {
   print "Queue $queue: \t nodes used = $nodes_used{$queue}\t\t cpus used = $cpus_used{$queue}\n";
}

