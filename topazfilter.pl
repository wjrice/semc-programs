#! /usr/bin/perl -w
# topazfilter
# used to filter out poor particle score from topaz run
# wjr 030719
# input file is first argument, filter score is second argument , output file is third argument
# arguments optional
# usage
# topaz_filter <inputfile> <min_score> <outputfile>
#
# default as follows
my $infile='all_particles.star';
my $outfile='filtered_particles.star';
my $score = 0; # filter < this value
my $column=5-1; #default place i think probably not needed since it finds it


my $count=0;
if ($ARGV[0]) {$infile=$ARGV[0]};
if ($ARGV[1]) {$score=$ARGV[1]};
if ($ARGV[0]) {$outfile=$ARGV[2]};

open (IN,$infile) or die "cannot read $infile\n";
open (OUT,">$outfile") or die "cannot write $outfile\n";

while (<IN>) {
   @data=split(" ",$_);
   if ($#data <3) {
      print OUT; #write the line if less than 3 columns
      if ($data[0] =~ m/ParticleScore/) {
         $data[1] =~ s/#//;
         $column = $data[1]-1;#get rid of # and subtract 1
      }
   }
   else {
      if ($data[$column] >=$score) {print OUT;} #only write if particlescore >=$score
      else {$count++;}
   }
}
print "Finished! wrote $outfile after removing $count particles\n";


