export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

zstyle ':omz:update' mode disabled

ENABLE_CORRECTION="true"

HIST_STAMPS="yyyy-mm-dd"

plugins=(
	git
	vi-mode
)

source $ZSH/oh-my-zsh.sh