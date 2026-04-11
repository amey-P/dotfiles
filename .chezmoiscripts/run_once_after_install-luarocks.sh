#!/bin/bash

set -euo pipefail

# Luarocks - try package first, fallback to source build
if command -v luarocks &> /dev/null; then
    echo "luarocks already installed."
    exit 0
fi

echo "Building luarocks from source..."
LUAROCKS_VERSION=$(curl -s https://luarocks.github.io/luarocks/releases/ | grep -o 'luarocks-[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.gz' | head -n 1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

if [[ -z "$LUAROCKS_VERSION" ]]; then
    LUAROCKS_VERSION="3.11.1"
fi

echo "Using Luarocks version: ${LUAROCKS_VERSION}"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

curl -L "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" -o luarocks.tar.gz
tar xzf luarocks.tar.gz
cd "luarocks-${LUAROCKS_VERSION}"

./configure
make
sudo make install

cd /
rm -rf "$TEMP_DIR"
echo "Luarocks installation completed"