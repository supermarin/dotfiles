# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
#ZSH_THEME='robbyrussell'
#ZSH_THEME='pure'
ZSH_THEME='mneorr2'

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

