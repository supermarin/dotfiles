# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="../custom/themes/mneorr"
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(brew gem, bundler)

source $ZSH/oh-my-zsh.sh

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

if [ -f ~/.privaterc ]; then
  . ~/.privaterc
fi

# Powerline
#. ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/zsh/powerline.zsh

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
