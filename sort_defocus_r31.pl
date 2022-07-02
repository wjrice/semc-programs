#! /usr/bin/perl -w
# reads in a star file, outputs a star file with particles sorted into groups
# purpose is to correct for warnings about too few particles in a micrograph
# by default each microgrpah is its own group, but some micrographs amy have only a handful of particles
# by sorting into groups (default defocus group size 1000A) thi issue is avoided
# optionally sorts the output star file by defocus, otherwise output order is same as input
# also prints out number of groups found and particles per group, in case further combination is needed
# wjr 070716
#
# MODIFED 04/03/22 to read and write relion 3.1 format star files

my $input = 'particles.star';
my $groupsize = 1000; # angstroms -- size for groups
my $outlog = 'sort.log';
#write OUT, "test\n";
my @data;
my $sort_by_defocus=0;

print "Enter input file (default $input): ";
chomp ($line=<STDIN>);
if ($line) {$input = $line;}
my $output = 'sorted_' . $input;
print "Enter output file (default $output): ";
chomp ($line=<STDIN>);
if ($line) {$output=$line;}
print "Enter group size (default $groupsize): ";
chomp ($line=<STDIN>);
if ($line) {$groupsize=$line;}
print "Sort output by defocus (y/n, default n)? ";
$line=<STDIN>;
if ($line =~ m/y/i) {$sort_by_defocus=1;}

$gnum=0;

open (IN,$input) or die "cannot read\n";
open (OUT,">$output") or die "cannot write\n";
open (OUT2,">$outlog") or die "cannot write\n";

# optics group header
$line=<IN>;
while ($line !~ m/loop/) {
   print OUT $line;
   $line= <IN>;
   } 
print OUT $line ; #write loop
# micrograph data header
$line=<IN>;
while ($line !~ m/loop/) {
   print OUT $line;
   $line= <IN>;
   } 
print OUT $line ; #write loop


#read header
$line = <IN>;
while ($line =~ m/_rln(\w+)\s\#(\d+)/) {
   $type=$1;
   $itemnum=$2;
   print OUT $line;
   $header{$type} = $itemnum -1 ; #array numbers start at 0 while relion starts at 1
   chomp $line; 
   print "header $line type $type itenmum $itemnum\n";
   if ($type eq 'GroupNumber') {
      print "GroupNumber Found\n";
      $gnum=1;
   }
   $line = <IN>;
}

@keys = sort keys (%header);
print "keys found in header: @keys\n";
#   @data=split(" ",$line);
#   print "header DefocusU $header{'DefocusU'}\n";
#   print "header DefocusV $header{'DefocusV'}\n";
#   $df_avg = ($data[$header{'DefocusU'}] + $data[$header{'DefocusV'}])/2;
#   print "df avg = $df_avg\n";

#die;
@data=split(" ",$line);
$lastitem = $#data+1;
while ($#data>2) {
   $df_avg = ($data[$header{'DefocusU'}] + $data[$header{'DefocusV'}])/2;
   push (@data,$df_avg);
   $group = int($df_avg/$groupsize);
   $groupname = sprintf("groupid%.3d", $group);
   $data[$header{'MicrographName'}] = $groupname; # replace micrograph name with group name  
   if ($gnum) {$data[$header{'GroupNumber'}] = $group;}  # if groupnumber is in header, replace it with the newly claculated group number
   $count[$group]++ ;
   push (@alldata,[@data]); #make arrary of arrays
   $line = <IN>;
   @data=split(" ",$line);
}
close (IN);

if ($sort_by_defocus) {
   @sorted_by_df = sort { $a->[$lastitem] <=> $b->[$lastitem] } @alldata ; 
}
else {
   @sorted_by_df = @alldata;
}

for ($i=0; $i<$#sorted_by_df; $i++) {
   @individual = @{$sorted_by_df[$i]};
   $df_avg = pop @individual;
#   print "$df_avg\n";
   $outline = join (' ',@individual);
   print OUT "$outline\n";
}
print "Combining particles into defocus groups of size $groupsize A\n";
for ($i=0; $i <= $#count; $i++) {
   $min = $i * $groupsize;
   $maxi = ($i+1) * $groupsize;
   unless ($count[$i]) {$count[$i]=0;}
   print "Group $i has $count[$i] particles df range $min to $maxi \n";
   print OUT2 "Group $i has $count[$i] particles df range $min to $maxi \n";

}
close (OUT2);

