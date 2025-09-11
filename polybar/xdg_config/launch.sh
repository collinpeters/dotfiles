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

echo "Bars launched..."
