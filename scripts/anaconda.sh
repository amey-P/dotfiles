#!/bin/bash

set -e

# Source the installer utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/installer.sh"

echo "Setting up Anaconda..."

# Determine system architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ANACONDA_ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    ANACONDA_ARCH="aarch64"
else
    error "Unsupported architecture: $ARCH"
    exit 1
fi

# Fetch latest Anaconda version for Linux
ANACONDA_VERSION=$(curl -s https://repo.anaconda.com/archive/ | grep -o "Anaconda3-[0-9]\{4\}\.[0-9]\{2\}-Linux-${ANACONDA_ARCH}.sh" | sort -r | head -n 1)
if [ -z "$ANACONDA_VERSION" ]; then
    error "Failed to fetch latest Anaconda version"
    exit 1
fi

DOWNLOAD_URL="https://repo.anaconda.com/archive/${ANACONDA_VERSION}"
INSTALLER="/tmp/${ANACONDA_VERSION}"

echo "Downloading Anaconda installer..."
if ! curl -o "$INSTALLER" -L "$DOWNLOAD_URL"; then
    error "Failed to download Anaconda installer"
    exit 1
fi

echo "Installing Anaconda..."
if ! bash "$INSTALLER" -b -p "$HOME/anaconda3"; then
    error "Failed to install Anaconda"
    rm -f "$INSTALLER"
    exit 1
fi

# Clean up the installer
rm -f "$INSTALLER"

# Initialize Anaconda
CONDA_PATH="$HOME/anaconda3/bin/conda"

# Initialize conda for the current shell
eval "$("$CONDA_PATH" shell.bash hook)"

# Update conda
echo "Updating conda..."
"$CONDA_PATH" update -n base -c defaults conda -y

# Initialize conda in shell rc files if not already done
if ! grep -q "# >>> conda initialize >>>" "$HOME/.bashrc"; then
    "$CONDA_PATH" init bash
fi

if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "# >>> conda initialize >>>" "$HOME/.zshrc"; then
        "$CONDA_PATH" init zsh
    fi
fi

# Create a default environment with commonly used packages
echo "Creating default environment..."
"$CONDA_PATH" create -n default python=3 numpy pandas scipy matplotlib jupyter -y

echo "Anaconda installation completed successfully!"
echo "To start using Anaconda, restart your shell or run: source ~/.bashrc (or ~/.zshrc if using zsh)"

