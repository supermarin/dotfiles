source ~/.config/fish/nix.fish

# Env
# set -gx VISUAL 'gvim -f' #TODO: brokeh w/ nix
set -gx EDITOR 'vim'
set -gx FUZZY fzf
set -gx GOBIN ~/.local/bin
set -gx GOPATH $HOME/code/go
set -gx MAILDIR $HOME/.mail
set -gx PASS_STORE ~/.password-store
set -gx PATH ~/.local/bin $PATH
set -gx RIPGREP_CONFIG_PATH $HOME/.rgrc

# Aliases
if status --is-interactive
    abbr c clear
    abbr g git
    abbr l la
end
