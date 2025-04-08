# Define colors
red="%F{red}"
normal="%f"
cyan="%F{cyan}"
green="%F{green}"
purple="%F{magenta}"
chocolate="%F{214}"

# Check if inside a git repository
is_in_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null
}

# Get the current git branch name
git_branch_name() {
  git symbolic-ref --short --quiet HEAD
}

# Get the current git commit hash
git_current_commit() {
  git log --pretty=format:'%h' -n 1
}

# Check if the git repository is dirty
is_git_dirty() {
  git status -s --ignore-submodules=dirty &>/dev/null
}

# Get the number of stashed changes
stashed() {
  if git rev-parse --verify refs/stash &>/dev/null; then
    echo "S$(git stash list | wc -l | tr -d ' ')"
  fi
}

# Get the number of commits ahead of the upstream branch
ahead() {
  local ahead_count=$(git rev-list --left-only --count HEAD...@'{u}' 2>/dev/null)
  if [ "$ahead_count" -gt 0 ]; then
    echo "↑$ahead_count"
  fi
}

# Get the number of commits behind the upstream branch
behind() {
  local behind_count=$(git rev-list --right-only --count HEAD...@'{u}' 2>/dev/null)
  if [ "$behind_count" -gt 0 ]; then
    echo "↓$behind_count"
  fi
}

# Generate the git prompt
git_prompt() {
  local branch=$(git_branch_name)
  local git_status_color
  local revision

  if [ -n "$branch" ]; then
    git_status_color=$green
    revision=$branch
  else
    local current_commit=$(git_current_commit)
    if [ -n "$current_commit" ]; then
      git_status_color=$purple
      revision=$current_commit
    fi
  fi

  if is_git_dirty; then
    git_status_color=$chocolate
  fi

  echo "$git_status_color$revision$purple$(stashed)$normal$(ahead)$normal$(behind)"
}

# Display nix-shell prompt if inside a nix-shell
nix_shell() {
  if [ -n "$IN_NIX_SHELL" ]; then
    echo "${green}nix-shell$normal"
  else
    echo "$normal"
  fi
}

# Display SSH prompt if connected via SSH
ssh_prompt() {
  if [ -n "$SSH_CONNECTION" ]; then
    echo "$cyan$USER$normal@$cyan$HOST$normal"
  fi
}

# Generate the jj prompt
jj_prompt() {
  if ! command -v jj &>/dev/null; then
    return 1
  fi

  if ! jj root --quiet &>/dev/null; then
    return 1
  fi

  jj log --ignore-working-copy --no-graph --color always -r @ -T '
    surround(
      "",
      "",
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
}

precmd() {
  if jj root --quiet &>/dev/null; then
    local vcs=" $(jj_prompt)%f "
  elif is_in_git_repo; then
    local vcs=" $(git_prompt)%f "
  fi

  local stuff="$(ssh_prompt)$vcs$(nix_shell)"
  export PROMPT="%(1j.[%j jobs] .)%(0?..%F{red}[%?]%f )${stuff} ➜ "
}

chpwd() {
  [[ -n "$TMUX" ]] && tmux rename-window "$(basename "$PWD")"
  # Update terminal title with current directory
  print -Pn "\e]0;%~\a"
}
