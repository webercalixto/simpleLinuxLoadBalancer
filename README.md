# simpleLinuxLoadBalancer
License: GNU General Public License v3.0

This is a simple load balancer for linux. 
Interface names are defined in interfaces.sh:
$IF_LAN = Your local lan interface name (e.g. eth0/enps303/etc)
$IF_LINK1 = Your first internet uplink interface name. Prefer it to be a no-quota link. 
$IF_LINK1 = Your second internet uplink interface name. May be a 4G link, etc.

Notes:

1) Use NetworkManager to setup ip, netmasks, dialup, etc.

2) Bittorrent traffic thru $IF_LINK2 is blocked to avoid exceending quota on this interface.
