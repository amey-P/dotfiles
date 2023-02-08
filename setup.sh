#! /bin/sh

sudo sh scripts/su_setup.sh $1

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source ~/.cargo/env
cargo install alacritty exa bat fd nu

# Tmux Setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm $HOME/{.zshrc}


# Populating configs
ls -d */ | grep -v scripts | xargs stow

env "$POWERLINE_CONFIG_COMMAND" tmux setup
powerline-config tmux setup
