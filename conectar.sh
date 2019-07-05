#!/bin/bash
echo  "########## CONECTAR.SH ####"
touch /tmp/conectar
date
	echo 'Not online'
	./conectar_cdc.sh  $1
	./conectar_USB0.sh  $1
	./conectar_USB1.sh  $1


