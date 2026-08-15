activate() {
    source $(find $1 -regex ".*/bin/activate$")
}

eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$HOME/.opencode/bin:$PATH