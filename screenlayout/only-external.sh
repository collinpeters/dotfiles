#!/bin/bash

CONNECTED=$(xrandr | grep " connected " | awk '{ print$1 }')

# First turn off external displays
if [[ $CONNECTED = *"HDMI-0"* ]]; then
	echo "Setting HDMI off"
	xrandr --output HDMI-0 --off
fi
if [[ $CONNECTED = *"DP-3"* ]]; then
	echo "Setting DP-3 off"
	xrandr --output DP-3 --off
fi
if [[ $CONNECTED = *"DP-3.8"* ]]; then
	echo "Setting DP-3.8 off"
	xrandr --output DP-3.8 --off
fi

# Laptop display
xrandr --output DP-0 --off

# Asus on DisplayPort (Seems to switch between DP-3.8 and DP-3)
DP=""
if [[ $CONNECTED = *"DP-3.8"* ]]; then
	echo "Setting Asus on DP-3.8 to right of laptop display"
	xrandr --output DP-3.8 --auto --mode 3840x2160 --panning 3840x2160+0+0 --pos 0x0
	DP="DP-3.8"
elif [[ $CONNECTED = *"DP-3"* ]]; then
	echo "Setting Asus on DP-3 to right of laptop display"
	xrandr --output DP-3 --auto --mode 3840x2160 --panning 3840x2160+0+0 --pos 0x0
	DP="DP-3"
fi

# Dell on HDMI
if [[ $CONNECTED = *"HDMI-0"* ]]; then
	echo "Setting Dell/HDMI-0 to right of Asus/$DP"
	xrandr --output HDMI-0 --auto --panning 3840x2160+3840+0 --right-of $DP;
fi

sleep 1

~/.config/polybar/launch.sh
