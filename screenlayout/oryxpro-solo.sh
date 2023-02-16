#!/bin/sh
xrandr \
	--output DP-0 --auto --mode 3840x2160 --panning 3840x2160+0+0 --pos 0x0 --rotate normal \
	--output HDMI-0 --off \
	--output DP-3.8 --off \
	--output DP-3 --off

sleep 3

~/.config/polybar/launch.sh
