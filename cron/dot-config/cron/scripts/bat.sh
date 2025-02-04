#!/bin/bash

BATTERY_PATH="/sys/class/power_supply/BAT0"
HIBERNATE_TIME=2  # Time in minutes

# Read battery values
CURRENT_CAPACITY=$(cat "$BATTERY_PATH/energy_now")
DISCHARGE_RATE=$(cat "$BATTERY_PATH/power_now")
STATUS=$(cat "$BATTERY_PATH/status")

# Check if the battery is discharging
if [ "$STATUS" = "Discharging" ]; then
    if [ "$DISCHARGE_RATE" -gt 0 ]; then
        # Calculate remaining time in minutes
        REMAINING_TIME=$(echo "scale=4; ($CURRENT_CAPACITY / $DISCHARGE_RATE) * 60" | bc)
        if (( $(echo "$REMAINING_TIME < $HIBERNATE_TIME" | bc -l) )); then
            notify-send -u critical "Battery low. Shutting down."
            doas ZZZ
        fi
    fi
else
    echo "Battery is not discharging."
fi
