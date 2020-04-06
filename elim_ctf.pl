#! /usr/bin/perl -w
# eliminate micrographs with outlying defocus angles 
# wjr 030417
#

my $input = 'micrographs_ctf.star';
my $err=5; #default = astig +/- 5 degrees

print "Enter input file (default $input): ";
chomp (my $line=<STDIN>);
if ($line) {$input = $line;}
open (IN,$input) or die "cannot read\n";
print "Enter desired astigmatism angle: ";
chomp ($astig=<STDIN>);
print "Enter error (default $err): ";
chomp ($line=<STDIN>);
if ($line =~ m/^\d+\.?\d*$/) {$err=$line;}
my $output = 'edited_' . $input;
my $min = $astig - $err;
my $max = $astig + $err;

open (OUT,">$output") or die "cannot write to $output\n";


$line=<IN>;
while ($line !~ m/loop/) {
   print OUT $line;
   $line= <IN>;
} 
print OUT $line;
#read header
$line = <IN>;
while ($line =~ m/_rln(\w+)\s\#(\d+)/) {
   print OUT $line;
   $type=$1;
   $itemnum=$2;
   $header{$type} = $itemnum -1 ; #array numbers start at 0 while relion starts at 1
   chomp $line; 
   print "header $line type $type itenmum $itemnum\n";
   $line = <IN>;
}
print OUT $line;

my @keys = sort keys (%header);
print "keys found in header: @keys\n";

my @data=split(" ",$line);
my %count;
my $total=0;
my $goodtotal=0;
while ($#data>2) {
   $total += 1;
   $df_angle =$data[$header{'DefocusAngle'}];
   if (($df_angle > $min) and ($df_angle < $max)) {
      print OUT $line; 
      $goodtotal += 1;
   }
   $line = <IN>;
   if ($line) {@data=split(" ",$line);}
   else {@data = ('blank');}
}
if ($line) {print OUT $line;}
while ($line=<IN>) {
   print OUT $line;
}
close (IN);
close (OUT);

print "Wrote $goodtotal micrographs out of $total\n";
print "with astig angle between $min and $max\n";

