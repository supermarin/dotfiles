# GTFO Vi mode in shell
bindkey -e

# Source custom environment and aliases
source ~/.env
source ~/.aliases

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
