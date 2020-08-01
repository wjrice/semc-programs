#! /usr/bin/perl -w

my $isdata='is_data_20jul29c.txt';
my $dfdata='df_diff_20jul29c.txt';

my $out='data_20jul29c.csv';

open (IN,$isdata) or die "cannot read $isdata\n";
my %isxdata;
my %isydata;
while (<IN>) {
   my @data=split(" ",$_);
   my $name=$data[1];
   my $isx=$data[2];
   my $isy=$data[3];
   $isxdata{$name}=$isx;
   $isydata{$name} = $isy;
}
close(IN);

my %df;
open (IN,$dfdata) or die "cannot read $dfdata\n";
while (<IN>) {
   my @data=split(" ",$_);
   my $name = shift @data;
   $name =~s/n-.$/n.mrc/;
   my $dfdiff = pop @data;
   $df{$name} = $dfdiff;
}
close (IN);

open (OUT,">$out") or die "cannot write $out\n";
print OUT "isx,isy,df_diff\n";
my @keys = sort keys(%df);
foreach my $key (@keys) {
   if (exists($isxdata{$key})) {
      print OUT "$isxdata{$key},$isydata{$key},$df{$key}\n";
   }
}


