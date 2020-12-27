set red (set_color -o red)
set normal (set_color normal)
set cyan (set_color -o cyan)
set green (set_color -o green)
set purple (set_color -o brpurple)
set chocolate (set_color -o D2691E)

function is_in_git_repo
    echo (git rev-parse --is-inside-work-tree ^/dev/null)
end

function git_branch_name
    echo (git symbolic-ref --short --quiet HEAD)
end

function git_current_commit
    echo (git log --pretty=format:'%h' -n 1)
end

function is_git_dirty
    echo (git status -s --ignore-submodules=dirty ^/dev/null)
end

function stashed
    set -l testStash (git rev-parse --verify refs/stash ^/dev/null)

    if [ $status = 0 ]
        echo "S"(git stash list | wc -l | tr -d ' ')
    end
end

function jobs_info
  set -l jobs_no (jobs | wc -l | tr -d ' ')
  if [ $jobs_no = 1 ]
    echo "[$jobs_no job]"
  else if [ $jobs_no -ge 2 ]
    echo "[$jobs_no jobs]"
  end
  set -e $jobs_no
end

function ahead
    set -l ahead_count (git rev-list --left-only --count HEAD...@'{u}' ^/dev/null)
    if [ $ahead_count ]
        if [ $ahead_count -gt 0 ]
            echo "↑$ahead_count"
        end
    end
end

function behind
    set -l behind_count (git rev-list --right-only --count HEAD...@'{u}' ^/dev/null)
    if [ $behind_count ]
        if [ $behind_count -gt 0 ]
            echo "↓$behind_count"
        end
    end
end

function git_prompt
    set -l branch (git_branch_name)
    if [ $branch ]
        set git_status_color $green
        set revision $branch
    else
        set -l current_commit (git_current_commit)
        if [ $current_commit ]
            set git_status_color $purple
            set revision $current_commit
        end
    end

    if [ (is_git_dirty) ]
        set git_status_color $chocolate
    end

    echo $git_status_color$revision $purple(stashed) $normal(ahead) $normal(behind)
end


function fish_prompt
    set -l s $status # needed because $status gets overriden to 0 immediately
    if [ $s -ne 0 ]
      set last_status_info $red$s
    end

    if [ (is_in_git_repo) ]
      set supemarin_git_info (git_prompt)
    end

    echo (jobs_info) $supemarin_git_info $last_status_info $normal'$ '
end
