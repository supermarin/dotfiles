function fish_prompt


    function git_branch_name
      echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    end

    function git_current_commit
      echo (git log --pretty=format:'%h' -n 1 ^/dev/null)
    end

    function is_git_dirty
      echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end

  set -l red (set_color -o red)
  set -l normal (set_color normal)
  set -l cyan (set_color cyan)
  set -l purple (set_color purple)

  if [ (git_branch_name) ]
    set -l git_status_color $cyan

    if [ (is_git_dirty) ]
      set git_status_color $red
    end

    set git_info $git_status_color(git_branch_name)

  else if [ (git_current_commit) ]
    set git_info $purple(git_current_commit)
  end

  echo $git_info "$normal\$ "
end

