function MN_is_git_dirty() {
    #dirty=$(echo git status -s --ignore-submodules=dirty ^/dev/null)
    #if [ -le $dirty ]; then
        #return true
    #else
        #return false
    #fi
    #return ( dirty -ne 0 )
    echo $(git status -s --ignore-submodules=dirty ^/dev/null)
}

prompt_pure_git_dirty() {
    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null

    (($? == 1)) && echo '*'
}

function git_color() {
    command git diff --quiet --ignore-submodules HEAD &>/dev/null
    if [ $? -ne 0 ]; then
        echo "%{$fg[red]%}"
    else
        echo "%{$reset_color%}"
    fi
}

function dirtyness() {
#echo "WAT: $(MN_is_git_dirty)"
echo "WAT: `prompt_pure_git_dirty`"
if [ -n $(MN_is_git_dirty) ]; then
    echo "DIRTY"
else
    echo "NOT DIRTY"
fi
}

local ret_status="%(?:%{$fg[green]%}$ :%{$fg[red]%}$)"
#local git_color="$(is_git_dirty?:%{$fg[green]%}$ :%{$fg[red]%}$)"
#PROMPT='$(git_color)$(git_prompt_info) ${ret_status}%{$reset_color%}'
PROMPT='$(dirtyness) ${ret_status}%{$reset_color%}'

#function fish_prompt


    #function git_branch_name
      #echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    #end

    #function git_current_commit
      #echo (git log --pretty=format:'%h' -n 1 ^/dev/null)
    #end

    #function is_git_dirty
      #echo (git status -s --ignore-submodules=dirty ^/dev/null)
      ##echo (git diff --quiet --ignore-submodules HEAD) # this is the fastest, use it the right way
    #end

  #set -l red (set_color -o red)
  #set -l normal (set_color normal)
  #set -l cyan (set_color cyan)
  #set -l purple (set_color purple)

  #if [ (git_branch_name) ]
    #set -l git_status_color $cyan

    #if [ (is_git_dirty) ]
      #set git_status_color $red
    #end

    #set git_info $git_status_color(git_branch_name)

  #else if [ (git_current_commit) ]
    #set git_info $purple(git_current_commit)
  #end

  #echo $git_info "$normal\$ "
#end

