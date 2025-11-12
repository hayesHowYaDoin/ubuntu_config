#!/usr/bin/env bash

# Post-install script to disable conflicting GNOME extensions
# Run this after home-manager installation

set -e

echo "Disabling GNOME extensions that may conflict with configuration..."

# Check if gnome-extensions command is available
if ! command -v gnome-extensions &> /dev/null; then
    echo "Warning: gnome-extensions command not found. Skipping extension disable."
    echo "This is expected if you're not running GNOME or haven't installed gnome-shell yet."
    exit 0
fi

# Disable ding extension (desktop icons)
if gnome-extensions list | grep -q "ding@rastersoft.com"; then
    echo "Disabling ding@rastersoft.com..."
    gnome-extensions disable ding@rastersoft.com || echo "Note: Could not disable ding@rastersoft.com"
else
    echo "ding@rastersoft.com not found or already disabled."
fi

# Disable tiling-assistant extension
if gnome-extensions list | grep -q "tiling-assistant@ubuntu.com"; then
    echo "Disabling tiling-assistant@ubuntu.com..."
    gnome-extensions disable tiling-assistant@ubuntu.com || echo "Note: Could not disable tiling-assistant@ubuntu.com"
else
    echo "tiling-assistant@ubuntu.com not found or already disabled."
fi

echo "Extension disable process complete!"
