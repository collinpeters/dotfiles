#!/bin/bash

if [[ $CONNECTED = *"HDMI-0"* ]]; then
  echo "Launching polybar on mandalay HDMI-0 (left)"
  $POLYBAR -c /home/collin/.config/polybar/config-mandalay.ini mandalay-left &
fi

if [[ $CONNECTED = *"DP-0"* ]]; then
  echo "Launching polybar on mandalay DP-0 (middle)"
  $POLYBAR -c /home/collin/.config/polybar/config-mandalay.ini mandalay-middle &
fi

if [[ $CONNECTED = *"DP-2"* ]]; then
  echo "Launching polybar on mandalay DP-2 (right)"
  $POLYBAR -c /home/collin/.config/polybar/config-mandalay.ini mandalay-right &
fi
