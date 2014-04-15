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

