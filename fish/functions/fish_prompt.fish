set red (set_color -o red)
set normal (set_color normal)
set cyan (set_color -o cyan)
set green (set_color -o green)
set purple (set_color -o brpurple)
set chocolate (set_color -o D2691E)

function is_in_git_repo
    echo (git rev-parse --is-inside-work-tree 2>/dev/null)
end

function git_branch_name
    echo (git symbolic-ref --short --quiet HEAD)
end

function git_current_commit
    echo (git log --pretty=format:'%h' -n 1)
end

function is_git_dirty
    echo (git status -s --ignore-submodules=dirty 2>/dev/null)
end

function stashed
    set -l testStash (git rev-parse --verify refs/stash 2>/dev/null)

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
    set -l ahead_count (git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null)
    if [ $ahead_count ]
        if [ $ahead_count -gt 0 ]
            echo "↑$ahead_count"
        end
    end
end

function behind
    set -l behind_count (git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null)
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

function duration
  if [ $CMD_DURATION -gt 100 ]
    echo " $normal($CMD_DURATION ms)"
  end
end

function nix_shell
  if [ $IN_NIX_SHELL ]
    echo $green'nix-shell> '$normal
  else
    echo $normal'$ '
  end
end

function ssh_prompt
  if [ $SSH_CONNECTION ]
    echo $cyan$USER$normal'@'$cyan(hostname)$normal
  end
end

function jj_prompt --description 'Write out the jj prompt'
    if not command -sq jj
        return 1
    end

    if not jj root --quiet &>/dev/null
        return 1
    end

    jj log --ignore-working-copy --no-graph --color always -r @ -T '
        surround(
            "(",
            ")",
            separate(
                " ",
                bookmarks.join(", "),
                coalesce(
                    surround(
                        "\"",
                        "\"",
                        if(
                            description.first_line().substr(0, 24).starts_with(description.first_line()),
                            description.first_line().substr(0, 24),
                            description.first_line().substr(0, 23) ++ "…"
                        )
                    ),
                    "(no description set)"
                ),
                change_id.shortest(),
                commit_id.shortest(),
                if(conflict, "(conflict)"),
                if(empty, "(empty)"),
                if(divergent, "(divergent)"),
                if(hidden, "(hidden)"),
            )
        )
    '
end

function fish_prompt
    set -l s $status # needed because $status gets overriden to 0 immediately
    if [ $s -ne 0 ]
      set last_status_info $red$s
    end

    if [ (is_in_git_repo) ]
      set marin_vcs_info (git_prompt)
    end

    if jj root --quiet &>/dev/null
      set marin_vcs_info (jj_prompt)
    end

    echo (jobs_info) (ssh_prompt) $marin_vcs_info $last_status_info(duration) (nix_shell)
end
