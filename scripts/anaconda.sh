#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Set Miniconda URL for Linux
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# Check if conda is already installed
if command -v conda &> /dev/null; then
    echo -e "${GREEN}Miniconda is already installed${NC}"
    exit 0
fi

echo "Installing Miniconda..."

# Create temporary directory
TMP_DIR=$(mktemp -d)
INSTALLER_PATH="$TMP_DIR/miniconda_installer.sh"

# Download installer
echo "Downloading Miniconda installer..."
wget -q --show-progress "$MINICONDA_URL" -O "$INSTALLER_PATH"

# Run installer
echo "Running Miniconda installer..."
bash "$INSTALLER_PATH" -b -p "$HOME/miniconda3"

# Clean up
rm -rf "$TMP_DIR"

# Initialize conda for shell
"$HOME/miniconda3/bin/conda" init "$(basename "$SHELL")"

# Disable auto activation of base environment
"$HOME/miniconda3/bin/conda" config --set auto_activate_base false
