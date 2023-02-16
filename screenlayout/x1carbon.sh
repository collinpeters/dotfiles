#!/bin/bash

CONNECTED=$(xrandr | grep " connected " | awk '{ print$1 }')

# First turn off external display
#if [[ $CONNECTED = *"HDMI-1"* ]]; then
#	echo "Setting HDMI off"
#	xrandr --output HDMI-1 --off
#fi

# Laptop display
#xrandr --output eDP-1 --auto --mode 1920x1080 --panning 1920x1080+0+0 --pos 0x0 --rotate normal

# Asus on HDMI
if [[ $CONNECTED = *"HDMI-1"* ]]; then
	echo "Setting Asus/HDMI-1 to right of laptop/$DP"
	#xrandr --output HDMI-1 --auto --panning 3840x2160+1920+0 --right-of eDP-1;


	# 3840+(1920*2) = 7680
	# 2160+(1080*2) = 4320
	#xrandr --dpi 192 --fb 7680x4320 \
	#	--output eDP-1  --scale 2x2 \
	#	--output HDMI-1 --mode 3840x2160 --right-of eDP-1 --panning 3840x2160+1920+0 

	#xrandr \
	#	--output eDP-1 --pos 5120x0 --auto \
	#	--output HDMI-1 --pos 0x0 --auto --scale 2x2

	#xrandr --dpi 228 --fbmm 7680x4320 \
	xrandr --dpi 228 \
		--output eDP-1 --scale 2x2 --mode 1920x1080 --pos 0x0 --primary \
		--output HDMI-1 --scale 1x1 --mode 3840x2160 --pos 3840x0

	#xrandr --fbmm 11520x4200 \
	#	--output eDP --pos 4320x2400 --mode 2880x1800 --scale 1x1 --primary \
	#	--output DisplayPort-1 --pos 0x0 --mode 1920x1200 --scale 2x2 \
	#	--output DisplayPort-0 --pos 3840x0 --mode 1920x1200 --scale 2x2 \
	#	--output HDMI-0 --pos 7680x0 --mode 1920x1200 --scale 2x2

#Screen 0: minimum 320 x 200, current 5760 x 2160, maximum 8192 x 8192
#eDP-1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 309mm x 174mm
#   1920x1080     60.05*+  60.01    59.97    59.96    59.93  
#HDMI-1 connected 3840x2160+1920+0 (normal left inverted right x axis y axis) 621mm x 341mm
#   3840x2160     30.00*+  30.00    25.00    24.00    29.97    23.98  
			
	# 1920 * 2 = 3840
	# 1080 * 2 = 2160
	
	# Framebuffer = 3840x2160 + 3840x2160 = 7680x4320

	# 1920x1080+0+0
	# 3840x2160+1920+0
else
	xrandr --dpi 228 \
		--output eDP-1 --scale 2x2 --mode 1920x1080 --pos 0x0 --primary \
		--output HDMI-1 --off
fi

sleep 1

~/.config/polybar/launch.sh
