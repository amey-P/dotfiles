setopt correct
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt nocheckjobs
setopt numericglobsort
setopt nobeep
setopt appendhistory
setopt histignorealldups
setopt autocd

setopt prompt_subst

export PATH=$PATH:$HOME/.local/bin
export PATH="$HOME/.local/share/elixir-ls/release:$PATH"

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
WORDCHARS=${WORDCHARS//\/[&.;]}
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8