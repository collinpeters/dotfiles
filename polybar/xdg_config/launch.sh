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
AUTORANDR_CURRENT=$(autorandr --current)

if [ "$HOSTNAME" = "mandalay" ]; then
	if [[ $CONNECTED = *"DP-0"* ]]; then
    echo "Launching polybar on mandalay DP-0 (left)"
		$POLYBAR -c /home/collin/.config/polybar/config-mandalay-forest.ini mandalay-left &
	fi
	if [[ $CONNECTED = *"DP-2"* ]]; then
    echo "Launching polybar on mandalay DP-2 (middle)"
		$POLYBAR -c /home/collin/.config/polybar/config-mandalay-forest.ini mandalay-middle &
	fi
	if [[ $CONNECTED = *"HDMI-0"* ]]; then
    echo "Launching polybar on mandalay HDMI-0 (right)"
		$POLYBAR -c /home/collin/.config/polybar/config-mandalay-forest.ini mandalay-right &
	fi
elif [ "$HOSTNAME" = "stratosphere" ]; then
  if [[ $AUTORANDR_CURRENT = "stratosphere-triple-4k" ]]; then
    echo "Launching polybar on stratosphere triple 4k"
    $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-triple-4k.ini stratosphere-left &
    $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-triple-4k.ini stratosphere-middle &
    $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-triple-4k.ini stratosphere-right &
  else
    echo "Launching polybar on stratosphere eDP-1"
    $POLYBAR -c /home/collin/.config/polybar/config-stratosphere-laptop-only stratosphere-edp1 &
  fi
elif [ "$HOSTNAME" = "aria" ]; then
	if [[ $CONNECTED = *"DP-0"* ]]; then
		echo "Launching polybar on aria DP-0"
		$POLYBAR -c /home/collin/.config/polybar/config-aria.ini aria-only &
	fi
elif [ "$HOSTNAME" = "mirage" ]; then
	if [[ $CONNECTED = *"eDP-1"* ]]; then
		echo "Launching polybar on mirage eDP-1"
		echo "HERE"
		$POLYBAR -c /home/collin/.config/polybar/config-mirage mirage-edp1 &
	fi
else
	if [[ $CONNECTED = *"DP-0"* ]]; then
		echo "Launching polybar on DP-0"
		$POLYBAR dp0 &
	fi 

	if [[ $CONNECTED = *"DP-3.8"* ]]; then
		echo "Launching polybar on DP-3.8"
		$POLYBAR dp38 &
	elif [[ $CONNECTED = *"DP-3"* ]]; then
		echo "Launching polybar on DP-3"
		$POLYBAR dp3 &
	fi

	if [[ $CONNECTED = *"HDMI-0"* ]]; then
		echo "Launching polybar on HDMI-0"
		$POLYBAR hdmi0 &
	fi
fi


echo "Bars launched..."
