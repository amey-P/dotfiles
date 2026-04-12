alias xo='xdg-open'

if [[ -z "$TMUX" ]]; then
    ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )"
    if [[ -z "$ID" ]]; then
        tmux new-session
    else
        tmux attach-session -t "$ID"
    fi
fi

macchina

ANDROID_HOME=$HOME/Android/sdk
PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
PATH=$PATH:$ANDROID_HOME/platform-tools

export ANDROID_HOME
export PATH