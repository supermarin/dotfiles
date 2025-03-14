#!/usr/bin/env fish

function wo
  set --local dir (find -L ~/code -maxdepth 2 | fzf)

  if ! [ $dir ]
    return 1
  end

  if test $TMUX
    # TODO: open new tab in tmux?
    tmux rename-window (basename $dir)
  end

  cd $dir
  clear
  la
end

