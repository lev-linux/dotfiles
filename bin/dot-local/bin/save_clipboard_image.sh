#!/bin/bash

# Directory to save images
IMAGE_DIR="images"
# Ensure the directory exists
mkdir -p "$IMAGE_DIR"

# Generate a unique filename based on timestamp
FILENAME="$(date +%Y%m%d_%H%M%S).png"

# Full path to save the image
FILEPATH="$IMAGE_DIR/$FILENAME"

# Check for clipboard tool and save the clipboard image
if command -v wl-paste &> /dev/null; then
    wl-paste --type image/png > "$FILEPATH"
elif command -v xclip &> /dev/null; then
    xclip -selection clipboard -t image/png -o > "$FILEPATH"
else
    echo "Error: No compatible clipboard tool found (requires wl-paste or xclip)." >&2
    exit 1
fi

# Notify the user
if [[ -s "$FILEPATH" ]]; then
    echo "Image saved to $FILEPATH"
else
    echo "Error: Failed to save image. Make sure an image is in the clipboard." >&2
    rm $FILEPATH
    exit 1
fi
