# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME='robbyrussell'

plugins=()

source $ZSH/oh-my-zsh.sh


function safely_load() {
  if [ -f $1 ]; then source $1; fi
}

safely_load ~/.aliases
safely_load ~/.privaterc
safely_load ~/.env

