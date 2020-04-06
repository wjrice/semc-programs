#! /usr/bin/perl -w
#script to update defocus values of particles.star file to local defocus values
#currentlt assumes:
#	1 run in extracted particles directory
#	2 original coords needed to match
#	3 local files in ../../micrographs/*local.star
#	4 local was run on esn-a and picking on esn-a-DW
#
#wjr 101317
#
my @starfiles = glob ("../../micrographs/*local.star");
foreach $file (@starfiles) {
   print "working on file $file\n";
   open (IN,$file) or die "no read $file\n";
   while (<IN>) {
      next unless (m/micrographs/);
      @data = split(" ",$_);
      $name = $data[0];
      $name =~ s/e([sn])n-a/e$1n-a-DW/;
      $coord_x = $data[1];
      $coord_y = $data[2];
      $coord = join(",",($coord_x,$coord_y));
      $dfu{$name}{$coord} = $data[4];
      $dfv{$name}{$coord} = $data[5];
      $ang{$name}{$coord} = $data[6];
   }
   close (IN);
}
my $particles = 'particles.star';
my $newparticles = 'particles_local.star';
open (IN,$particles) or die "no read $particles\n";
open (OUT,">$newparticles") or die "no write $newparticles\n";
while (<IN>) {
   unless (m/micrographs/) {print OUT;next}
   @data = split(" ",$_);
   $name = $data[3];
   $coord = join (",",$data[0],$data[1]);
   if ($dfu{$name}{$coord}) { 
      $data[5] = $dfu{$name}{$coord};
      $data[6] = $dfv{$name}{$coord};
      $data[7] = $ang{$name}{$coord};
      $newline = join("  ",@data);
      print OUT "$newline\n";
      $j++;
   }
   else {
      print "Warning: no updated defocus for $name. rewriting original line\n";
      print OUT;
      $i++;
   }
}

print "changed $j particles\n"; 
print "did not change $i particles\n"; 
