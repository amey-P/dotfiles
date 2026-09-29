activate() {
    source $(find $1 -regex ".*/bin/activate$")
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh