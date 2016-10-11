# GTFO Vi mode in shell
bindkey -e

# Source custom environment and aliases
source ~/.env
source ~/.aliases

# Plugins
source "$HOME/.antigen/antigen.zsh"

antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle tarruda/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search


# Load the theme.
antigen theme robbyrussell

# Not sure if this is still needed
antigen apply

## FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Temporary conference hack
# export PS1='$ '
