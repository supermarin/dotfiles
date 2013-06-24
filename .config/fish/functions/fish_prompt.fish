function fish_prompt

  if not set -q -g __fish_robbyrussell_functions_defined
    set -g __fish_robbyrussell_functions_defined
    
    function _git_branch_name
      echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    end
    
    function _is_git_dirty
      echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end
  end

  set -l red (set_color -o red)
  set -l normal (set_color normal)
  set -l cyan (set_color cyan)

  if [ (_git_branch_name) ]
    set -l git_status_color $cyan
    
    if [ (_is_git_dirty) ]
      set git_status_color $red
    end

    set git_info $git_status_color(_git_branch_name)
  end

  echo $git_info "$normal\$ "
end
