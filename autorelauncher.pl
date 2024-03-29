#! /usr/bin/perl -w
# program to run appion auto relauncher for automated sessions
# runs through sessions with --no-wait option so it does not pause
# endless loop, so you need to kill it once it is done
# wjr 04-25-23 
# NYU Langone

unless (defined $ARGV[2]) {
   die "Usage: $0 <old Appion session> <new session basename> <range> /\n Example: $0 23apr18a 23apr21 a-c,f,k-m \n"; 
}
my $old_session = $ARGV[0];
my $new_base = $ARGV[1];
my $range = $ARGV[2];

my @subranges = split/,/,$range; #split on comma
my @sesletters;

foreach my $subrange (@subranges) {
   my ($beg,$end) = split("-",$subrange);
   push @sessionletters,($end? $beg .. $end : $beg);
}

while (1) {
   foreach my $let (@sessionletters) {
      print "appion autoRelauncher.py --old-session=$old_session --no-wait --new-session=$new_base$let\n";
      `appion autoRelauncher.py --old-session=$old_session --no-wait --new-session=$new_base$let`;
   }
   print "finished loop, sleeping\n";
   sleep 5; #seconds
}
 
 
