#! /usr/bin/perl -w
#script to simplify running of dqe program
# wjr 030517
#
my $epp=80 ; #default total electrons per pixel
print "mrc files in directory:\n";
my @files = glob ("*.mrc");
foreach $file (@files) {print "$file\n";}
print "Enter blank image: ";
chomp (my $image1=<STDIN>);
unless (-e $image1) {die "cannot find $image1\n";}
print "Enter beamstop image: ";
chomp (my $image2 = <STDIN>);
unless (-e $image2) {die "cannot find $image2\n";}
print "Enter total electrons per pixel (default $epp): ";
chomp (my $line=<STDIN>);
if ($line=~ m/^\d+\.?\d*$/) {$epp=$line;}
unless (-e 'logs') {mkdir 'logs';}
unless (-e 'residuals') {mkdir 'residuals';}

$image2 =~ m/(.*)\.mrc/;
my $base=$1;
my $log = $base . '.log';
my $command= "/emg/sw/FindDQE/bin/finddqe.exe < tmp.txt >& logs/$log";

open (OUT, ">tmp.txt") or die "cannot write tmp.txt file\n";
print OUT << "EOF"
2
$epp
1
2
$image2
$image1
residuals/${base}-res.mrc
EOF
;
close (OUT);

print "running finddqe in background\n";
defined(my $pid = fork) or die "Cannot fork: $!";
unless ($pid) {
   exec $command;
   die "cannot exec $command: $!";
}
