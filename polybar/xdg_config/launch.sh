#!/bin/bash

HOSTNAME=$(hostname)
POLYBAR=$(which polybar)

if [ -z $PROFILE ]; then
	PROFILE=$USER
fi

echo "Launching polybar for host: $HOSTNAME"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

CONNECTED=$(xrandr | grep " connected " | awk '{ print$1 }')

source "$HOME/.config/polybar/launch-${HOSTNAME}.sh"

# if [ "$HOSTNAME" = "mandalay" ]; then
# elif [ "$HOSTNAME" = "stratosphere" ]; then
#AUTORANDR_CURRENT=$(autorandr --current)
#   if [[ $AUTORANDR_CURRENT = "stratosphere-triple-4k" ]]; then
#     echo "Launching polybar on stratosphere triple 4k"
#     $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-triple-4k.ini stratosphere-left &
#     $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-triple-4k.ini stratosphere-middle &
#     $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-triple-4k.ini stratosphere-right &
#   else
#     echo "Launching polybar on stratosphere eDP-1"
#     $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-single-1080.ini stratosphere-edp1 &
#   fi
# elif [ "$HOSTNAME" = "mirage" ]; then
# else
#   if [[ $CONNECTED = *"DP-0"* ]]; then
#     echo "Launching polybar on DP-0"
#     $POLYBAR dp0 &
#   fi 
#
#   if [[ $CONNECTED = *"DP-3.8"* ]]; then
#     echo "Launching polybar on DP-3.8"
#     $POLYBAR dp38 &
#   elif [[ $CONNECTED = *"DP-3"* ]]; then
#     echo "Launching polybar on DP-3"
#     $POLYBAR dp3 &
#   fi
#
#   if [[ $CONNECTED = *"HDMI-0"* ]]; then
#     echo "Launching polybar on HDMI-0"
#     $POLYBAR hdmi0 &
#   fi
# fi
#

echo "Bars launched..."
