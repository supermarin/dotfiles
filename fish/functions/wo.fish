#!/usr/bin/env fish

set --local dir (find -L ~/code -maxdepth 2 | fzf)
if [ $dir ]
  cd $dir
  clear
  la
end
