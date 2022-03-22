#! /bin/sh

sudo sh scripts/su_setup.sh

# Populating configs
ls -d */ | grep -v scripts | xargs stow


# Tmux Setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
