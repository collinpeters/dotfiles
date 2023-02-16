#!/bin/bash

# Laptop display
xrandr --output DP-0 --auto --mode 3840x2160 --panning 3840x2160+0+0 --pos 0x0 --rotate normal

CONNECTED=$(xrandr | grep " connected " | awk '{ print$1 }')

# Asus on HDMI at home
if [[ $CONNECTED = *"HDMI-0"* ]]; then
	echo "Setting HDMI to right of laptop display"
	xrandr --output HDMI-0 --auto --panning 3840x2160+3840+0 --right-of DP-0
else
	echo "Setting HDMI off"
	xrandr --output HDMI-0 --off
fi

# Dell on DisplayPort (Seems to switch between DP-3.8 and DP-3)
if [[ $CONNECTED = *"DP-3.8"* ]]; then
	echo "Setting DP-3-8 to right of HDMI(Asus) display"
	xrandr --output DP-3.8 --auto --panning 3840x2160+7680+0 --right-of HDMI-0;
elif [[ $CONNECTED = *"DP-3"* ]]; then
	echo "Setting DP-3 to right of HDMI(Asus) display"
	xrandr --output DP-3 --auto --panning 3840x2160+7680+0 --right-of HDMI-0;
else
	echo "Setting DP-3.8 and DP-3 off"
	xrandr --output DP-3.8 --off --output DP-3 --off
fi

sleep 1

~/.config/polybar/launch.sh
