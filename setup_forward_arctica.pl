#! /usr/bin/perl -w
# wjr 
# updated 7/1/21 to add forwarding of microscope screen sharing directly to port forwarding pc
#

my $start_port=49153;
my $end_port = 51000;

my $private_ip = '192.168.0.5';
#my $public_ip = '10.163.4.73';   # ORIGINAL, changed on 12-13-21 at 9 pm to address below
my $public_ip = '10.163.4.81';
my $microscope_ip='192.168.0.1';
my $leginon_ip='10.163.4.65';
my $database_ip='10.150.168.11';
my $support_ip = '192.168.0.2';

`iptables -F`;
`iptables -F -t nat`;
`echo 1 > /proc/sys/net/ipv4/ip_forward`;
`iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport 55555 -j DNAT --to $microscope_ip:55555`;
`iptables -t nat -A PREROUTING -p tcp -d $private_ip  --dport 3306 -j DNAT --to $database_ip:3306`;
`iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport 5905 -j DNAT --to $microscope_ip:5900`;
`iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport 445 -j DNAT --to $microscope_ip:445`;


print "setting up forwarding...\n";
for ($port=$start_port; $port<= $end_port; $port++) {
   print "iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport $port -j DNAT --to $microscope_ip:$port\n";
   `iptables -t nat -A PREROUTING -p tcp -d $public_ip --dport $port -j DNAT --to  $microscope_ip:$port`;
   `iptables -t nat -A PREROUTING -p tcp -d $private_ip --dport $port -j DNAT --to $leginon_ip:$port`;
   print "iptables -t nat -A PREROUTING -p tcp -d $private_ip --dport $port -j DNAT --to $leginon_ip:$port\n";
}
`iptables -t nat -A POSTROUTING -j MASQUERADE`;
