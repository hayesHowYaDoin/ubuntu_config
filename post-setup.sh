#!/usr/bin/env bash

# Post-setup script to configure shell and GNOME extensions
# Run this after home-manager has installed all packages

set -e

echo "Setting default shell to zsh..."

# Get the path to zsh (installed by nix home-manager)
ZSH_PATH=$(which zsh)

if [ -z "$ZSH_PATH" ]; then
    echo "Error: zsh not found in PATH. Make sure home-manager has installed it."
    exit 1
fi

echo "Found zsh at: $ZSH_PATH"

# Check if zsh is already the default shell
if [ "$SHELL" = "$ZSH_PATH" ]; then
    echo "zsh is already the default shell."
else
    # Add zsh to /etc/shells if not already present
    if ! grep -q "^$ZSH_PATH$" /etc/shells 2>/dev/null; then
        echo "Adding $ZSH_PATH to /etc/shells (requires sudo)..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi

    # Change the default shell
    echo "Changing default shell to zsh (requires password)..."
    chsh -s "$ZSH_PATH"

    echo "Default shell changed successfully!"
    echo "Please log out and log back in for the changes to take effect."
fi

echo ""
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

# Disable ubuntu-dock extension (conflicts with just-perfection dash settings)
if gnome-extensions list | grep -q "ubuntu-dock@ubuntu.com"; then
    echo "Disabling ubuntu-dock@ubuntu.com..."
    gnome-extensions disable ubuntu-dock@ubuntu.com || echo "Note: Could not disable ubuntu-dock@ubuntu.com"
else
    echo "ubuntu-dock@ubuntu.com not found or already disabled."
fi

echo "Post-setup complete!"
