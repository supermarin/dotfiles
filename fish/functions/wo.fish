#!/usr/bin/env fish

function wo
  set --local dir (find -L ~/code -maxdepth 2 | fzf)

  if [ $dir ]
    cd $dir
    clear
    la

    if test $TMUX
      # TODO: open new tab in tmux?
      tmux rename-window (basename $dir)
    end
  end
end
