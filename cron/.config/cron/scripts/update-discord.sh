#!/bin/bash

# Path to void-packages
VOID_PACKAGES_DIR="/home/salastro/.srcpkgs/void-packages/"

# Update the repository
cd "$VOID_PACKAGES_DIR" || exit
git pull

# Update and build Discord
./xbps-src update-check discord
./xbps-src pkg discord

# Install the updated package
doas xi -y discord && notify-send "Discord updated" || notify-send "Discord update failed"
