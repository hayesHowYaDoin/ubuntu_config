#!/usr/bin/env bash

# Post-setup script to configure shell and other system settings
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
