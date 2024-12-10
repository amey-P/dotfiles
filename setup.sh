#! /bin/bash

run_command() {
	echo "============================================================================"
	echo -e "\t\t\t\t$1"
	echo "============================================================================"
	echo

	# Running
	eval $2

	# Logging
	if [[ $? -eq 0 ]]; then
	  echo -e "\n\n\033[1;32mSUCCESS: $1\033[0m\n\n"
	else
	  echo -e "\n\n\033[1;31mERROR: $1 failed with exit code $?\033[0m\n\n"
	fi
}

declare -A tasks=(
	["Package Installation"]="./scripts/installer.sh"
	["Rust Setup"]="./scripts/rust.sh"
	["Anaconda Installer"]="./scripts/anaconda.sh"
	["Oh My ZSH"]="./scripts/zsh.sh"
	["Tmux Pluging Manager"]="./scrips/tmux.sh"
	["Populating Configs"]="ls -d */ | grep -v scripts | xargs stow"
	["Powerline Setup"]="./scripts/powerline.sh"
	["Neovim Setup"]="./scripts/nvim.sh"
)

for task_name in "${!tasks[@]}"; do
  run_command "$task_name" "${tasks[$task_name]}"
done

# # Tmux Setup
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#
# # Oh My ZSH
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# rm $HOME/{.zshrc}
#
#
# # Populating configs
# ls -d */ | grep -v scripts | xargs stow
#
# env "$POWERLINE_CONFIG_COMMAND" tmux setup
# powerline-config tmux setup
