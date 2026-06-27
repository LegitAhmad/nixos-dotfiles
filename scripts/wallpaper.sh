#!/usr/bin/env bash

# Define the target path
TARGET_DIR="$HOME/nixos-dotfiles/config/assets"
TARGET_PATH="$TARGET_DIR/wallpaper.jpg"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Check if the environment variable is provided and the file exists
if [ -z "$NOCTALIA_WALLPAPER_PATH" ] || [ ! -f "$NOCTALIA_WALLPAPER_PATH" ]; then
    echo "Error: NOCTALIA_WALLPAPER_PATH is not set or file does not exist." >&2
    exit 1
fi

# Detect the file extension (lowercase)
EXTENSION="${NOCTALIA_WALLPAPER_PATH##*.}"
EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

if [ "$EXTENSION" = "jpg" ] || [ "$EXTENSION" = "jpeg" ]; then
    # If it's already a JPG, just copy it directly
    cp "$NOCTALIA_WALLPAPER_PATH" "$TARGET_PATH"
else
    # If it's a PNG or other format, convert it using ImageMagick
    # Note: Using 'magick' command (standard in newer ImageMagick versions)
    if command -v magick &> /dev/null; then
        magick "$NOCTALIA_WALLPAPER_PATH" "$TARGET_PATH"
    elif command -v convert &> /dev/null; then
        # Fallback for older ImageMagick v6 installations
        convert "$NOCTALIA_WALLPAPER_PATH" "$TARGET_PATH"
    else
        echo "Error: ImageMagick (magick or convert) is required for image conversion." >&2
        exit 1
    fi
fi
