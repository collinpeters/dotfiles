#!/bin/sh

# Home dock setup: laptop screen off, three external 4k monitors

# turn all displays off first
#xrandr --output DP-0  --off \
#      --output DP-1  --off \
#      --output DP-2  --off \
#      --output DP-3  --off \
#      --output DP-4  --off \
#      --output DP-5   --off \
#      --output HDMI-0 --off

xrandr --dpi 228 \
  --output HDMI-0 --mode 3840x2160 --pos 0x0    --panning 3840x2160+0+0    --primary \
  --output DP-4   --mode 3840x2160 --pos 3840x0 --panning 3840x2160+3840+0 \
  --output DP-0   --mode 3840x2160 --pos 7680x0 
