#! /usr/bin/perl -w
#
open (IN,'allparticles_BoxNet2_20180602.star') or die "no read\n";
while (<IN>) {
   my @data=split(" ",$_);
   next unless ($#data>2);
   my $file = pop (@data);
   unless (-e "already_copied/$file") {`touch already_copied/$file`;}
}
 


