source ~/.config/fish/nix.fish

# Env
set -gx PATH $PATH ~/.local/bin
set -gx EDITOR vim
# set -gx VISUAL 'gvim -f'
set -gx RIPGREP_CONFIG_PATH $HOME/.rgrc
set -gx MAILDIR $HOME/.mail
set -gx GOPATH $HOME/code/go
set -gx GOBIN ~/.local/bin

# Aliases
if status --is-interactive
    abbr c clear
    abbr g git
    abbr l la
    # backported functions from zsh
    alias cc "zsh -c 'source ~/.aliases && cc'"
    alias p "zsh -c 'source ~/.aliases && p'"
    alias pe "zsh -c 'source ~/.aliases && pe'"
    alias pw "zsh -c 'source ~/.aliases && pw'"
    alias s "zsh -c 'source ~/.aliases && s'"
end
