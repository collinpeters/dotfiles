#!/bin/bash

echo "Launching polybar on venetian Virtual 1"
$POLYBAR -c /home/collin/.config/polybar/config-venetian.ini Virtual1 &

VIRTUAL2=$(xrandr --query | grep "Virtual2 connected" | wc -l)
if [ "$VIRTUAL2" -eq "1" ]; then
  echo "Launching polybar on venetian Virtual 2"
  $POLYBAR -c /home/collin/.config/polybar/config-venetian.ini Virtual2 &
fi

VIRTUAL3=$(xrandr --query | grep "Virtual3 connected" | wc -l)
if [ "$VIRTUAL3" -eq "1" ]; then
  echo "Launching polybar on venetian Virtual 3"
  $POLYBAR -c /home/collin/.config/polybar/config-venetian.ini Virtual3 &
fi
