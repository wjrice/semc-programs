#! /usr/bin/perl -w
#
open (IN,"pace_lam10a_ts_006.mrc.mdoc") or die "no read\n";
open (OUT,">pace_lam10a_ts_006.mrc.mdoc.fixed") or die "no write\n";
while (<IN>) {
   if (m/TiltAngle/) {
      my @data = split(" ",$_);
      my $newangle = pop @data;
      $newangle -= 18;
      push @data,$newangle;
      my $str = join(" ",@data);
      print OUT "$str\n";
   }
   else {
      print OUT;
   }
}

