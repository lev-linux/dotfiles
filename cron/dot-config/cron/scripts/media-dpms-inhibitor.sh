#!/bin/bash

# Disable DPMS and screen blanking
disable_dpms() {
  echo "Disable DPMS"
  xset -dpms
  # xset s off
}

# Re-enable DPMS and screen blanking
enable_dpms() {
  echo "Enable DPMS"
  xset +dpms
  # xset s on
}

# Monitor media playback
playback_status=$(playerctl status)
echo $playback_status

if [[ "$playback_status" == "Playing" ]]; then
  disable_dpms
else
  enable_dpms
fi
