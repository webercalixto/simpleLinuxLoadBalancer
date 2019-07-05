#!/bin/bash

echo -e "\n ifconfig.me: "
curl ifconfig.me 
echo -e "\n icanhazip.com: "
curl icanhazip.com
echo -e "\n ipecho.net: "
curl ipecho.net/plain
echo -e "\n ifconfig.co: "
curl ifconfig.co
echo -e "\n ipinfo.io: "
curl https://ipinfo.io/ip
echo -e "\n checkip.dyndns.org: "
curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
echo -e "\n checkip.dyndns.org: "
curl https://ipecho.net/plain
echo -e "\n myip.opendns.com: "
dig +short myip.opendns.com @resolver1.opendns.com
echo -e "\n myaddr.l.google.com: "
dig TXT +short o-o.myaddr.l.google.com @ns1.google.com
echo -e "\n ident.me: "
curl ident.me
echo -e "\n checkip.amazonaws.com: "
curl http://checkip.amazonaws.com
echo -e "\n bot.whatismyipaddress.com: "
curl bot.whatismyipaddress.com


echo -e "\n "
