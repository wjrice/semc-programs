#! /usr/bin/perl -w
#
use File::Basename;
my $newdir='rawdata3';
#my $olddir = '/mnt/md0/cryosparc_user/P3/J1/imported';
my $olddir = 'rawdata2';

my @oldfiles = glob("$olddir/*.mrc");
foreach my $file (@oldfiles) {
	my $base=basename($file);
	if (-e "$newdir/$base") {unlink "$newdir/$base"; print "deleted link $newdir/$base\n";$i++;}
}
print "removed $i files\n";

