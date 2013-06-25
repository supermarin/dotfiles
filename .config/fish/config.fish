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
function la
  ls -lah
end

function findproccess
  ps ax |grep -i
end

function stupidXcode
  rm -rf ~/Library/Developer/Xcode/DerivedData
end

function ccat
  pygmentize -g
end

function sshvps
  ssh -i ~/.ssh/jack.pem ubuntu@mneorr.com
end

### Git
function gl
  git l
end

function gp
  git push
end

function gl
  git pull --rebase
end

function gs
  git status -sb
end

### Gem development
function pod-dev
  set COCOA_PODS_ENV development
  ~/code/OSS/CocoaPods/CocoaPods/bin/pod $argv
end
