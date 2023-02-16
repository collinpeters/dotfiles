#!/bin/sh
xrandr \
  --dpi 286 \
	--output DP-0 --auto --mode 3840x2160 --panning 3840x2160+0+0 --pos 0x0 --rotate normal 

sleep 3

~/.config/polybar/launch.sh
