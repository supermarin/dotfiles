# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME='supermarin'

plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


function safely_load() {
  if [ -f $1 ]; then source $1; fi
}

safely_load ~/.aliases
safely_load ~/.privaterc
safely_load ~/.env

# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[command]='fg=grey'
ZSH_HIGHLIGHT_STYLES[alias]='fg=grey'
ZSH_HIGHLIGHT_STYLES[function]='fg=grey'

if [[ ! $TERM =~ screen ]]; then
    tmux attach -t supermarin &>/dev/null || tmux new -s supermarin
fi

