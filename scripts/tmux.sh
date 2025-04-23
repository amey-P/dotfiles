#!/bin/bash

set -e

# Create tmux configuration directory
TMUX_DIR="$HOME/.tmux"
TPM_DIR="$TMUX_DIR/plugins/tpm"

mkdir -p "$TMUX_DIR/plugins"

# Install TPM if not already installed
if [ -d "$TPM_DIR" ]; then
    echo "Removing Existing TPM Installation"
    rm -rf $TPM_DIR
fi

echo "Installing TPM..."
git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
