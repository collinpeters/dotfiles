#!/bin/bash

if [[ $CONNECTED = *"eDP-1"* ]]; then
  echo "Launching polybar on mirage eDP-1"
  $POLYBAR -c /home/collin/.config/polybar/config-mirage mirage-edp1 &
fi
