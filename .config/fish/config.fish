set fish_greeting ""

. ~/.private.fish

### PATH (default)
set -x PATH ~/bin /usr/bin /bin /usr/sbin /sbin

### pip
set -x PATH /Library/Python/2.7/bin $PATH

### Homebrew
set -x PATH /usr/local/bin $PATH

### Npm
set -x PATH /usr/local/share/npm/bin $PATH

### rbenv
set -x PATH $HOME/.rbenv/bin $PATH
set -x PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null ^&1

### Go
set -x GOPATH ~/code/go
set -x PATH $GOPATH/bin $PATH
#set -x GOBIN ~/bin

### JAVA
if test -f /usr/libexec/java_home
  set -x JAVA_HOME (/usr/libexec/java_home)
end

### Node
set -x PATH /usr/local/node/bin $PATH
set -x NODE_PATH /usr/local/node/lib/node_modules

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
  ssh -i ~/.ssh/id_rsa.pub mneorr@mneorr.com
end

function moshvps
  mosh mneorr@mneorr.com
end

### Git
#
function gp
  git push --recurse-submodules=on-demand $argv
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

function ga
  git add $argv
end

### Gem development
function pod-dev
  set COCOA_PODS_ENV development
  ~/code/OSS/CocoaPods/CocoaPods/bin/pod $argv
end
