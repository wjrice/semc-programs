#! /usr/bin/perl -w
#
#script to add optics groups to a relion 3.1+ star file
#divides each separate subsquare target (hl target) to a separate group
#purpose is to check CTF over time
#
# note: written specifically for star files converted from cs to star by pyem. 
# columns is positions assumed from that program
#
# wjr 06-21-22
#
unless ($ARGV[0]) {
   die "Usage: $0 <star file>\n";
}

my $file = $ARGV[0];
open (IN,$file) or die "cannot read $file\n";

my $group = 0;
my $oldsq = 0;
my $oldhl = 0;
my $done=0;
my @header;
my @header2;
my $opticsline;
while (<IN>) {
   chomp;
   if (m/mrc/) {
      my @data = split(" ",$_);
      if ($data[$#data] =~ /(\d+)sq_(\d+)hl/) {
         if ($oldsq < $1) {
            $oldsq = $1;
            $oldhl = $2;
            $group += 1;
         }
         elsif ($oldhl < $2) {
             $oldhl = $2;
             $group += 1;
         }
         $data[11] = $group;
         my $line = join (" ",@data);
         push @lines, $line;
      } 
   }
   else {
      if (not $done) {
         push @header, $_;
         if (m/lnImageDimensionality/) {
            $done += 1;
         }
      }
      elsif ($done <2) {
            $opticsline = $_;
            $done +=1;
         }
      else {
         push @header2, $_;
      }
   }    
}
close (IN);

my $outfile = $file . '.tmp';
open (OUT,">$outfile") or die "cannot write $outfile\n";
foreach my $line (@header) {
   print OUT "$line\n";
}
my @data = split(" ",$opticsline);
for (my $i=1; $i <= $group; $i++) {
   $data[3] = $i;
   my $line = join(" ",@data);
   print OUT "$line\n";
}
foreach my $line (@header2) {
   print OUT "$line\n";
}
foreach my $line (@lines) {
   print OUT "$line\n";
}
close (OUT);

rename ($file, "$file.orig") or die "Can't rename $file to $file.orig: $|";
rename ($outfile, $file) or die "Can't rename $outfile to $file $|";
