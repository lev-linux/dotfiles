#!/bin/sh

BATTERY=/sys/class/power_supply/BAT0
STATUS=$(cat $BATTERY/status)
CAPACITY=$(cat $BATTERY/capacity)

if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -lt 3 ]; then
  doas ZZZ
fi
