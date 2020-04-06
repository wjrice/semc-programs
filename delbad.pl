#! /usr/bin/perl -w
## to remove the particles where Relion warns there are too few per micrograph
#wjr 090317

my $log = 'run.out';
my $part = 'particles.star';
my $partedit = 'particles_edited.star';

open (IN,$log) or die "cannot read $log\n";
while (<IN>) {
   if (m/warning: There are only \d+ particles in micrograph (.*\.mrc)\./) {
      push @badlist,$1;
   }
}
print "removing following micrographs which relion warned about too few particles:\n";
foreach $bad (@badlist) {print "$bad\n";}
close (IN);
open (IN,$part) or die "cannot read $part\n";
open (OUT,">$partedit") or die "cannot write $partedit\n";
while (<IN>) {
   $orig++;
   $match=0;
   foreach $bad (@badlist) {
      if ($_ =~ m/$bad/) {
         $match=1;
         last;
      }
   }
   unless ($match) {print OUT $_;$new++;}
}
$diff = $orig - $new;
print "Removed $diff particles\n";
