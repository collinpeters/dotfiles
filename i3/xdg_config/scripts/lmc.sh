#!/bin/bash

#newvol="pkill -RTMIN+10 polybar"
#newmpd="pkill -RTMIN+11 polybar"

case "$1" in
	"up") pamixer --allow-boost --increase "$2" ; $newvol ;;
	"down") pamixer --allow-boost --decrease "$2" ; $newvol ;;
	"mute") pamixer --allow-boost --toggle-mute ; $newvol ;;
	"truemute") pamixer --allow-boost --mute ; $newvol ;;
	"toggle") mpc toggle ; $newmpd ;;
	"pause") mpc pause ; $newmpd ;;
	"forward") mpc seek +"$2" ; $newmpd ;;
	"back") mpc seek -"$2" ; $newmpd ;;
	"next") mpc next ; $newmpd ;;
	"prev") mpc prev ; $newmpd ;;
	"replay") mpc seek 0% ; $newmpd ;;
esac
exit
