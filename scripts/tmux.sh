#!/bin/bash

set -e

# Source the installer utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/installer.sh"

echo "Setting up TMux and TPM (Tmux Plugin Manager)..."

# Install tmux if not already installed
if ! command -v tmux >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y tmux
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm tmux
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y tmux
    else
        error "Could not install tmux. Please install it manually."
        exit 1
    fi
fi

# Create tmux configuration directory
TMUX_DIR="$HOME/.tmux"
TMUX_CONFIG="$HOME/.tmux.conf"
TPM_DIR="$TMUX_DIR/plugins/tpm"

mkdir -p "$TMUX_DIR/plugins"

# Install TPM if not already installed
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install plugins
echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

echo "TMux setup completed successfully!"
echo "Please restart your tmux server or run: tmux source ~/.tmux.conf"
echo "Use prefix + I (capital I) to install new plugins in the future"

