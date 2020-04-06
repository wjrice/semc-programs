#! /usr/bin/perl -w
# reads in a star file, outputs a star file with particles sorted into groups
# purpose is to correct for warnings about too few particles in a micrograph
# by default each microgrpah is its own group, but some micrographs amy have only a handful of particles
# by sorting into groups (default defocus group size 1000A) thi issue is avoided
# optionally sorts the output star file by defocus, otherwise output order is same as input
# also prints out number of groups found and particles per group, in case further combination is needed
# wjr 070716
#

my $input = 'particles_big.star';
my $groupadd = 100; # number to add to group num
#write OUT, "test\n";
my @data;

print "Enter input file (default $input): ";
chomp ($line=<STDIN>);
if ($line) {$input = $line;}
my $output = 'renum_' . $input;
print "Enter output file (default $output): ";
chomp ($line=<STDIN>);
if ($line) {$output=$line;}
print "Enter group number to add (default $groupadd): ";
chomp ($line=<STDIN>);
if ($line) {$groupadd=$line;}

$gnum=0;

open (IN,$input) or die "cannot read\n";
open (OUT,">$output") or die "cannot write\n";


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

@data=split(" ",$line);
while ($#data>2) {
   $data[$header{'MicrographName'}] =~  m/groupid(\d+)/ ; # find group name
   $group = $1 + $groupadd;
   $groupname = sprintf("groupid%.3d", $group);
   $data[$header{'MicrographName'}] = $groupname; # replace micrograph name with group name  
   if ($gnum) {$data[$header{'GroupNumber'}] = $group;}  # if groupnumber is in header, replace it with the newly claculated group number
   $count[$group]++ ;
   push (@alldata,[@data]); #make arrary of arrays
   $line = <IN>;
   @data=split(" ",$line);
}
close (IN);

for ($i=0; $i<$#alldata; $i++) {
   @individual = @{$alldata[$i]};
   $outline = join (' ',@individual);
   print OUT "$outline\n";
}
for ($i=0; $i <= $#count; $i++) {
   unless ($count[$i]) {$count[$i]=0;}
   print "Group $i has $count[$i] particles \n";
}

