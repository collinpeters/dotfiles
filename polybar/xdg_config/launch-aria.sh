#!/bin/bash

if [[ $CONNECTED = *"DP-0"* ]]; then
  echo "Launching polybar on aria DP-0"
  $POLYBAR -c /home/collin/.config/polybar/config-aria.ini aria-only &
fi
