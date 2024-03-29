#! /usr/bin/perl -w
# wjr 
# updated 7/1/21 to add forwarding of microscope screen sharing directly to port forwarding pc
#
# modified 4/7/23 for forwrading only to/dfrom krios k3 
# only needs one set of forwards since camera is on same netwrok, just firewalled
# point leginon to leginon2 pc
#
my $start_port=49153;
my $end_port = 54000;  # WAS 51000

my $private_ip = '10.163.4.125';
my $public_ip = '10.163.4.125';
my $camera_ip='10.133.128.33';
my $leginon_ip='10.163.4.125';
my $database_ip='10.150.168.11';

`iptables -F`;
`iptables -F -t nat`;
`echo 1 > /proc/sys/net/ipv4/ip_forward`;
`iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport 55555 -j DNAT --to $microscope_ip:55555`; #leginon
#`iptables -t nat -A PREROUTING -p tcp -d $private_ip  --dport 3306 -j DNAT --to $database_ip:3306`;  # mysql database 
#`iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport 5905 -j DNAT --to  $microscope_ip:5900`;  # vnc screen


print "setting up forwarding...\n";
for ($port=$start_port; $port<= $end_port; $port++) {
   print "iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport $port -j DNAT --to $camera_ip:$port\n";
   `iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport $port -j DNAT --to  $camera_ip:$port`;
#   `iptables -t nat -A PREROUTING -p tcp -d $private_ip --dport $port -j DNAT --to $leginon_ip:$port`;
#   print "iptables -t nat -A PREROUTING -p tcp -d $private_ip --dport $port -j DNAT --to $leginon_ip:$port\n";
}
`iptables -t nat -A POSTROUTING -j MASQUERADE`;
