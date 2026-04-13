#!/bin/bash

set -uo pipefail

if command -v luarocks &> /dev/null; then
    echo "luarocks already installed."
    exit 0
fi

echo "luarocks not found in PATH. Please ensure your package manager installed it."
exit 1
