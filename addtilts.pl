#! /usr/bin/perl -w
#
my $tilts = '../../groups.txt';
my $instar = 'run_data.star';
my $outstar = 'run_data_tilt.star';

open (IN,$tilts) or die "cannot read $tilts\n";
while (<IN>) {
   ($name,$tiltx,$tilty,$group)=split(" ",$_);
   $tiltx{$name} = $tiltx;
   $tilty{$name} = $tilty;
   $group{$name} = $group;
}
close (IN);

my $k=0;
open (IN,$instar) or die "cannot read $instar\n";
open (OUT,">$outstar") or die "cannot write $outstar\n";
# find start of relion defs
my $line = <IN>;
while ($line !~ m/loop_/) {
   print OUT $line;
   $line=<IN>;
}
print OUT $line;
my $num=1;
while (<IN>) {
   @data = split (" ",$_);
   if ($#data < 3) {
      print OUT;
      $num++;
      if ($data[0] =~ m/rlnMicrographName/) {
         $data[1] =~ s/#//;  #get rid od hash symbol
         $namecol = $data[1] -1; #relion start from 1
      }
   }
   else {
      if ($k<1) {
         print OUT "_rlnBeamTiltX #$num\n";
         $num++;
         print OUT "_rlnBeamTiltY #$num\n";
         $num++;
         print OUT "_rlnBeamTiltClass #$num\n";
         $name = $data[$namecol];
         push (@data,$tiltx{$name}, $tilty{$name}, $group{$name}); 
         $line = join(" ", @data);
         print OUT "$line\n";
      }
      else {
         $name = $data[$namecol];
         push (@data,$tiltx{$name}, $tilty{$name}, $group{$name}); 
         $line = join(" ", @data);
         print OUT "$line\n";
      }
      $k++;
   }
}

print "namecol is $namecol\n";
print "last name is $name\n";
#@keys = keys %tiltx;
#print @keys;

