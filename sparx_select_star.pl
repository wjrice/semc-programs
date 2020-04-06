#! /usr/bin/perl -w
# selects good classes from a star file using an EMAN/sparx lst file as input
# wjr 04212017

my $input = 'particles.star';
my $selfile = 'generation_1_accounted.txt';
my @data;

print "Enter input file (default $input): ";
chomp ($line=<STDIN>);
if ($line) {$input = $line;}
my $output = 'selected_' . $input;
print "Enter output file (default $output): ";
chomp ($line=<STDIN>);
if ($line) {$output=$line;}
print "Enter selection file: (default $selfile) ";
chomp ($line=<STDIN>);
if ($line) {$selfile=$line;}


open (IN,$input) or die "cannot read $input\n";
open (IN2,$selfile) or die "cannot read $selfile\n";
open (OUT,">$output") or die "cannot write to $output\n";

# store selected particles into array
my @selected; # selected classes
while ($line=<IN2>) {
   chomp ($line);
   push @selected,$line;
}
close (IN2);

$line=<IN>;
while ($line !~ m/loop/) {
   print OUT $line;
   $line= <IN>;
   } 
print OUT $line ; #write loop
#
#read header
$line = <IN>;
while ($line =~ m/_rln(\w+)\s\#(\d+)/) {
   print OUT $line;
   $line = <IN>;
}
# last line read to exit header is actually first data line
my @particles;
push @particles,$line;
# store all particles in array
while ($line=<IN>) {
   push @particles,$line;
}
close (IN);

my $total = $#particles +1;
my $totalsel = $#selected +1;
print "read in a total of $total particles.\n";
print "Saving $totalsel of these into $output\n";
foreach $pnum (@selected) {
#   print "saving particle $pnum\n";
   print OUT $particles[$pnum];
}
close (OUT);


