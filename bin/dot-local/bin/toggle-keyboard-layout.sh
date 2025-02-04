#!/bin/bash

# Query current keyboard layout
current_layout=$(setxkbmap -query | grep -oP 'layout:\s*\K\w+')

# Toggle between Arabic (ara) and US (us) layout
if [ "$current_layout" == "ara" ]; then
    setxkbmap us
else
    setxkbmap ara,us
fi

# Notify dwmblocks of the layout change
pkill -RTMIN+7 dwmblocks
