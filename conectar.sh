#!/bin/bash
touch /tmp/conectar
date
function ifup {
    if [[ ! -d /sys/class/net/${1} ]]; then
        printf 'No such interface: %s\n' "$1" >&2
        return 1
    else
        [[ $(</sys/class/net/${1}/operstate) == up ]]
    fi
}

if ifup wwx0c5b8f279a64; then
    echo 'Online'
else
	echo 'Not online'
	/home/pi/conectar_cdc.sh 
	/home/pi/conectar_USB0.sh 
	/home/pi/conectar_USB1.sh 
fi



