alias cp="cp -i"
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias ipython='ipython --TerminalInteractiveShell.editing_mode=vi'
alias l='exa'
alias neovide='NODE_PATH=$(which node) neovide'

alias gits="git status"
alias gitb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gitl="git log --graph --pretty=format:\"%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) [%an]\" --abbrev-commit -30"