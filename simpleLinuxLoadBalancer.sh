#!/bin/bash
set -o history -o histexpand
date
cd /home/pi
pwd
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

source interfaces.sh
source testaInterface.sh

IP_LINK1=$(/sbin/ip -o -4 addr list $IF_LINK1 | awk '{print $4}' | cut -d/ -f1)
IP_LINK2=$(/sbin/ip -o -4 addr list $IF_LINK2 | awk '{print $4}' | cut -d/ -f1)

testaInterface $IF_LINK2
if [ $? -eq 0 ]
then
	echo "$IF_LINK2 Nao tem IP"
	ifconfig $IF_LINK2 down
	python resetModem.py search "Huawei"
	sleep 10
	/home/pi/conectar.sh	
	sleep 10
	RECON_LINK2=1
else
	echo "$IF_LINK2 Tem IP"
	RECON_LINK2=0
fi

testaInterface $IF_LINK1
if [ $? -eq 0 ]
then
	echo "$IF_LINK1 Nao tem IP"
	ifconfig $IF_LINK1 down
	sleep 5
	ifconfig $IF_LINK1 up
	sleep 10
	RECON_LINK1=1
else
	echo "$IF_LINK1 Tem IP"
	RECON_LINK1=0
fi

if [ $RECON_LINK1 -eq 0 ] && [ $RECON_LINK2 -eq 0 ]
then
	echo 'TUDO OK. SAINDO ANTES'
	exit
fi

IP_LINK1=$(/sbin/ip -o -4 addr list $IF_LINK1 | awk '{print $4}' | cut -d/ -f1)
IP_LINK2=$(/sbin/ip -o -4 addr list $IF_LINK2 | awk '{print $4}' | cut -d/ -f1)
NET_LINK1=$(/sbin/ip -o -4 addr list $IF_LINK1 | awk '{print $6}' | cut -d/ -f1)
NET_LINK2=$(/sbin/ip -o -4 addr list $IF_LINK2 | awk '{print $6}' | cut -d/ -f1)
GW_LINK1=$(/sbin/ip route list dev $IF_LINK1 | awk '/default/ { print $3 }')
GW_LINK2=$(/sbin/ip route list dev $IF_LINK2 | awk '/default/ { print $3 }')

killall darkstat
sleep 1
darkstat -i $IF_LINK2 -p 668
darkstat -i $IF_LINK1 -p 667

echo "IF_LAN=$IF_LAN"
echo "IF_LINK1=$IF_LINK1"
echo "IF_LINK2=$IF_LINK2"
echo "GW_LINK1=|$GW_LINK1 |"
echo "GW_LINK2=$GW_LINK2"

route del default gw 192.168.0.1
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

echo 'HABILITANDO MASQUERADE' 
iptables -t nat -A POSTROUTING -o $IF_LINK1 -j MASQUERADE
iptables -t nat -A POSTROUTING -o $IF_LINK2 -j MASQUERADE

echo "DMZ PARA 192.168.0.20"
iptables  -t  nat  -A  PREROUTING  -i $IF_LINK1 -m state --state NEW -j DNAT --to-destination  192.168.0.20
#iptables  -t  nat  -A  PREROUTING  -i $IF_LINK2 -m state --state NEW -j DNAT --to-destination  192.168.0.20

echo "TENTANDO BLOQUEAR BITTORRENT"
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --match multiport --dports 6829:6999 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 59560 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 59508 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 6443 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 51413 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 8881 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 7881 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --dport 1357 -j DROP
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp -m ipp2p --bit -j DROP

iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p udp --match multiport --sports 1:3310 -j ACCEPT
iptables -t  mangle -I PREROUTING -i $IF_LINK2 -p tcp --match multiport --sports 1:3310 -j ACCEPT
iptables -t  mangle -A PREROUTING -i $IF_LINK2 -p tcp -j DROP
iptables -t  mangle -A PREROUTING -i $IF_LINK2 -p udp -j DROP

echo "EXCECOES DMZ PARA 192.168.0.20"
iptables  -t  nat  -I  PREROUTING  -p tcp --dport 667 -j ACCEPT
iptables  -t  nat  -I  PREROUTING  -p tcp --dport 668 -j ACCEPT
iptables  -t  nat  -I  PREROUTING  -p tcp --dport 22 -j ACCEPT
iptables  -t  nat  -I  PREROUTING  -p tcp --dport 5900 -j ACCEPT
iptables  -t  nat  -I  PREROUTING  -p tcp --dport 5901 -j ACCEPT
route del default gw 192.168.0.1
ip route add default scope global nexthop via $GW_LINK1 dev $IF_LINK1 weight 1 nexthop via $GW_LINK2 dev $IF_LINK2 weight 1
echo !!

ip route flush cache
echo '################## TERMINADO #################################'
ip route show table all


