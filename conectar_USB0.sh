#!/usr/bin/expect -f
set force_conservative 0  ;# set to 1 to force conservative mode even if
			  ;# script wasnt run conservatively originally

if {$force_conservative} {
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- $arg
	}
}

spawn /home/pi/simpleLinuxLoadBalancer/conectar_3G.sh ttyUSB0
match_max 100000
expect -exact "A password is required to connect to 'Claro connection'.\r
Password (gsm.password): "
send -- "a"
expect -exact "•"
send -- "j"
expect -exact "•"
send -- "k"
expect -exact "•"
send -- "1"
expect -exact "•"
send -- "2"
expect -exact "•"
send -- "l"
expect -exact "•"
send -- "3"
expect -exact "•"
send -- "2"
expect -exact "•"
send -- "\r"
expect eof

