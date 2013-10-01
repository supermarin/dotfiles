set fish_greeting ""

### PATH (default)
set -x PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin

### Private stuff
. ~/.private.fish

### pip
set -x PATH /Library/Python/2.7/bin $PATH

### Homebrew
set -x PATH /usr/local/bin $PATH

### Npm
set -x PATH /usr/local/share/npm/bin/ $PATH

### rbenv
set -x PATH $HOME/.rbenv/bin $PATH
set -x PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1

### Go
set -x GOPATH ~/code/go
set -x PATH $GOPATH/bin $PATH
#set -x GOBIN ~/bin

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
function la
  ls -lah $argv
end

function findproccess
  ps ax |grep -i $argv
end

function stupidXcode
  rm -rf ~/Library/Developer/Xcode/DerivedData
end

function ccat
  pygmentize -g $argv
end

function sshvps
  ssh -i ~/.ssh/jack.pem ubuntu@mneorr.com
end

function moshvps
  mosh mneorr@mneorr.com --ssh="ssh -i ~/.ssh/id_rsa.pub"
end

### Git
function gl
  git l $argv
end

function gp
  git push $argv
end

function gl
  git pull --rebase $argv
end

function gs
  git status -sb $argv
end

function gd
  git diff $argv
end

### Gem development
function pod-dev
  set COCOA_PODS_ENV development
  ~/code/OSS/CocoaPods/CocoaPods/bin/pod $argv
end
