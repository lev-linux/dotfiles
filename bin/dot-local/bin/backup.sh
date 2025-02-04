#!/bin/bash

# Define source and destination
SOURCE="$HOME/Documents"
DESTINATION="gdrive:Documents"
EXCLUDES="$HOME/.config/rclone/excludes.txt"
LOGFILE="$HOME/.cache/rclone/rclone.log"

# Perform the sync
mkdir -p ~/.cache/rclone
touch ~/.cache/rclone/rclone.log
rclone sync $SOURCE $DESTINATION --exclude-from $EXCLUDES --log-file $LOGFILE --progress

# Notify
if [ $? -eq 0 ]; then
    notify-send "Backup complete" "Backup of $(basename $SOURCE) to $DESTINATION complete"
else
    notify-send "Backup failed" "Backup of $(basename $SOURCE) to $DESTINATION failed"
fi
