#! /usr/bin/perl -w

my $outfile = "isac_particles.txt"; #output file
my @particles;
my @goodparticles;
open (IN,"generation_01_accounted.txt") or die "cannot find generation_1_accounted.txt\n";
while (<IN>) {push @goodparticles,$_;}
close (IN);
open (IN,'generation_01_unaccounted.txt') or die "cannot find generation_1_unaccounted.txt\n";
while (<IN>) {push @particles,$_;}
close (IN);

my $gen=2;
my $accountedfile = sprintf ("generation_%d_accounted.txt",$gen);
my $unaccountedfile = sprintf ("generation_%d_unaccounted.txt",$gen);
while (-e $accountedfile) {
   open (IN,$accountedfile);
   while (<IN>) {
      push @goodparticles,$particles[$_];
   }
   close (IN);
   open (IN,$unaccountedfile);
   @newparticlelist = ();
   while (<IN>) {
      push @newparticlelist,$particles[$_];
   }
   close (IN);

   $gen+= 1;
   $accountedfile = sprintf ("generation_%d_accounted.txt",$gen);
   $unaccountedfile = sprintf ("generation_%d_unaccounted.txt",$gen);
   @particles = @newparticlelist;
}
@goodparticles = sort {$a <=> $b} @goodparticles;
open (OUT,">$outfile") or die "cannot write $outfile\n";
foreach $part (@goodparticles) {print OUT $part;}
close (OUT);


