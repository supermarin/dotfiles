#!/usr/bin/env fish

set --local dir (find -L ~/code -maxdepth 2 | fzf)

if [ $dir ]
  cd $dir
  clear
  la
end

if test $TMUX
  # TODO: open new tab in tmux?
  tmux rename-window (basename $dir)
end
