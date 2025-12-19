#!/bin/bash

if [[ $CONNECTED = *"DP-0"* ]]; then
  echo "Launching polybar on mandalay DP-1"
  $POLYBAR -c /home/collin/.config/polybar/config-mandalay.ini mandalay-left &
fi

if [[ $CONNECTED = *"HDMI-0"* ]]; then
  echo "Launching polybar on mandalay HDMI-0"
  $POLYBAR -c /home/collin/.config/polybar/config-mandalay.ini mandalay-middle &
fi

if [[ $CONNECTED = *"DP-2"* ]]; then
  echo "Launching polybar on mandalay DP-2"
  $POLYBAR -c /home/collin/.config/polybar/config-mandalay.ini mandalay-right &
fi
