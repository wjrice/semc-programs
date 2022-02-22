#! /usr/bin/perl -w
#splits a warp goodparticles star file into sets based on thickness. Current sets are:
# < 30 nm
# 30-60 nm
# 60-90 nm
# 90-120 nm
# > 120 nm
#
unless (defined $ARGV[0]) {die "usage: split_thick.pl <position-thickness file>\n";}
my $infile = $ARGV[0];
my %thickness;
open (IN,$infile) or die "cannot read $infile\n";
while (<IN>) {
   my @data=split(" ",$_);
   my $thick = pop(@data);
   my $name = $data[0];
   $name =~ s/\.mrc/-a-DW_BoxNet2_20180602.mrcs/; 
   $thickness{$name}=$thick;
#   print "iname is $name\n";             ###################
}
close (IN);

my $star="goodparticles_BoxNet2_20180602.star";

my $numfiles = 5 ; #number of files to split, defined in next 2 lines
my @limits=(30,60,90,120);
my @outfile = ("lt_30.star", "30-60.star","60-90.star", "90-120.star", "ge_120.star");

my @n= (0,0,0,0,0);
open (IN,$star) or die "cannot read $star\n";
my @OUT = (OUT1, OUT2, OUT3, OUT4, OUT5);
for (my $i=0; $i<5; $i++) {
   open (*{$OUT[$i]},">$outfile[$i]") or die "cannot write $outfile[$i]\n";
}

while (<IN>) {
   for (my $i=0; $i<$numfiles; $i++) {
      print { $OUT[$i] } $_;
   }
   last if (m/_rlnMicrographName/);
}
while (<IN>) {
   my @data = split(" ",$_);
   my $name=$data[12];
   my @data2=split(/\//,$name);
   $name = pop @data2;
   if (not defined $thickness{$name}) {
      print "not defined $name\n";
   }
   else {
#   print "namne is $name\n"; die;            ###################
      my $thick = $thickness{$name};
      if ($thick<$limits[0]) {
         print {$OUT[0]} $_;
         $n[0]++;
      }
      elsif ($thick < $limits[1]) {
         print {$OUT[1]} $_;
         $n[1]++;
      }
      elsif ($thick < $limits[2]) {
         print {$OUT[2]} $_;
         $n[2]++;
      }
      elsif ($thick < $limits[3]) {
         print {$OUT[3]} $_;
         $n[3]++;
      }
      else {
         print {$OUT[4]} $_;
          $n[4]++;
      }   
   }
}
for (my $i=0; $i<$numfiles; $i++) {
   my $j=$i+1 ;
   print "n$j=$n[$i] ";
}
print "\n";

