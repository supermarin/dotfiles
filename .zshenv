export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

# pip
export PATH=~/Library/Python/2.7/bin/:$PATH

# Homebrew
export PATH=/usr/local/bin:$PATH

# Rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
#export PATH="$HOME/.rbenv/bin:$PATH"

# Terminal colors
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi
