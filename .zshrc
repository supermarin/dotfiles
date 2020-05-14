# Source custom environment and aliases
source ~/.env
source ~/.aliases

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh
fi
 

# emacs keys in shell prompt
bindkey -e

# ls colors
export LS_COLORS='no=00:fi=00:di=01;34:ln=39;35;01:pi=40;33:so=01;35:do=05;35:bd=40;33;01:cd=40;33;01:or=39;35;01:ex=01;31:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export CLICOLOR=1

# Special chars as file globs
setopt EXTENDED_GLOB
setopt prompt_subst
setopt nocasematch

# History
export HISTFILE=$HOME/.zhistory
export HISTSIZE=1000000000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE

# completions
autoload -Uz compinit
compinit -i
zmodload zsh/complist
setopt menucomplete
zstyle ':completion:*' menu select=0
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
bindkey -M menuselect '^[[Z' reverse-menu-complete

# fish-style autosuggestions
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Prompt
# PROMPT='$(prompt)'
