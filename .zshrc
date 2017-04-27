# GTFO Vi mode in shell
bindkey -e

# Source custom environment and aliases
source ~/.env
source ~/.aliases

# ls colors
export LS_COLORS='no=00:fi=00:di=01;34:ln=39;35;01:pi=40;33:so=01;35:do=05;35:bd=40;33;01:cd=40;33;01:or=39;35;01:ex=01;31:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export CLICOLOR=1

# Tab completion
autoload -Uz compinit
compinit -i

# Git info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' unstagedstr ' %F{1}M %f'
zstyle ':vcs_info:*' stagedstr ' %F{2}M %f'
zstyle ':vcs_info:*' stashstr ' %F{2}S %f'

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "⌥ %b%u%c%m"
zstyle ':vcs_info:*' actionformats "[%b%u%c] %F{4}%a%f"
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash git-untracked

setopt AUTO_MENU
setopt EXTENDED_GLOB # Special chars as file globs

setopt prompt_subst
setopt nocasematch

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

# History
HISTFILE=$HOME/.zhistory
HISTSIZE=1000000000000000
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# ls colors
export CLICOLOR=1


PROMPT='%F{4}%~%f '\$vcs_info_msg_0_"$ "
