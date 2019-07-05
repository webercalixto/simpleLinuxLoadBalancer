# simpleLinuxLoadBalancer
License: GNU General Public License v3.0
Author: Weber Calixto - webersouzacalixto at (gmail)

This is a simple load balancer for linux. 
Interface names are defined in interfaces.sh:
$IF_LAN = Your local lan interface name (e.g. eth0/enps303/etc)
$IF_LINK1 = Your first internet uplink interface name. Prefer it to be a no-quota link. 
$IF_LINK2 = Your second internet uplink interface name. May be a 4G link, etc.

$IF_LINK1 and $IF_LINK2 first are tested and if any connectivity issues are detected, the respective interface is reloaded. Then, the routing 

Notes:

1) Use NetworkManager to setup ip/dhcp, netmasks, dialup, etc.

2) Bittorrent traffic thru $IF_LINK2 is blocked to avoid exceending quota on this interface.

Usage:

1) Use NetworkManager to configure each interface accordingly to your setup
2) Edit interfaces.sh variables content to reflect your current setup
3) sudo ./simpleLinuxLoadBalancer.sh manually to test the script results
4) Set up a crontab to call simpleLinuxLoadBalancer.sh frequently.
