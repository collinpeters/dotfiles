#!/bin/sh
#xrandr --output DP-0 --auto --mode 3840x2160 --pos 0x0 --rotate normal \
#	--output DP-2.8 --auto --panning 3840x2160+3840+0 --right-of DP-0;

xrandr --output DP-0 --off;
xrandr --output DP-2 --off;
xrandr --output HDMI-0 --off;

xrandr --dpi 228 \
	--output DP-0 --mode 3840x2160 --pos 0x0 --panning 3840x2160+0+0 \
#	--output DP-2   --mode 3840x2160 --pos 3840x0 --panning 3840x2160+3840+0 --primary \
#	--output HDMI-0 --mode 3840x2160 --pos 7680x0
;

~/.config/polybar/launch.sh
