#!/bin/bash
source interfaces.sh
testaInterface(){
	echo "testaInterface: $1"
	ping -q -c15 -I $1 8.8.8.8 -i 0.3
	if [ $? -ne 0 ]
	then
		echo "testaInterface: $1 Nao tem IP"
		return 0
	else
		echo "testaInterface: $1 Tem IP"
		return 1
	fi	
}


