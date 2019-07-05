#!/bin/bash

echo "Tentando conectar $1..."
sudo nmcli device disconnect $1 --ask
sleep 2
sudo nmcli device connect $1 --ask
