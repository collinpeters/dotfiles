#!/bin/sh

# Laptop only
xrandr --dpi 228 \
  --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --off \
  --output DP-4 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
  --output DP-5 --off \
  --output DP-6 --off
