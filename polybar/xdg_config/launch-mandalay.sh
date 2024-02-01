#!/bin/bash

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
