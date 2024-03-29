#! /usr/bin/perl -w
#
# script to query Leginon db and hide named bad sessions
# for example empty sessins resulting from connection failure
# It will marke all session with name matching the desired name.
# Warning: There is no checking for how many sessions it will hide
# wjr 06-03-2023
#
use DBI;

my $bad_session_name = "NA";  # default bad session name
print "Enter name for session(s) to hide (default $bad_session_name): ";
chomp (my $line=<STDIN>);
if ($line) {$bad_session_name = $line;}

my $dbh = DBI -> connect('dbi:mysql:database=leginondb;host=10.150.38.162;port=3306;mysql_compression=1','usr_object','NYULMC123');
my $sql = "update SessionData set hidden=1 where comment = ?";
my $command=$sql;
$command =~ s/\?/\'$bad_session_name\'/;
print "Hiding sessions using the following command:\n$command\n";
my $stmt = $dbh->prepare($sql);
$stmt ->execute($bad_session_name);




