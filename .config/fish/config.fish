set fish_greeting ""

set PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin

### pip
set PATH $HOME/Library/Python/2.7/bin $PATH

### Homebrew
set PATH $HOME/usr/local/bin $PATH

### rbenv
set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1


### bundler

function be
  bundle exec $argv
end

function bi
  bundle install
end

function bu
  bundle update
end

### aliases
alias la="ls -lah"
alias findproccess="ps ax |grep -i"
alias stupidXcode="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias apacheSites="cd /Applications/XAMPP/xamppfiles/htdocs/"
alias duh="du -hc"
alias ccat='pygmentize -g'

alias sshvps="ssh -i ~/.ssh/jack.pem ubuntu@mneorr.com"

### Git
alias gl="git l"
alias gp="git push"
alias gl="git pull --rebase"
alias gs="git status -sb"

### Gem development
alias pod-dev='COCOA_PODS_ENV=development ~/code/OSS/CocoaPods/CocoaPods/bin/pod'
