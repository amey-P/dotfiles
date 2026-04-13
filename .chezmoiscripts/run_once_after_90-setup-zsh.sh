#!/bin/bash

set -euo pipefail

# Change default shell to zsh if not already set
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "Default shell is already zsh."
fi