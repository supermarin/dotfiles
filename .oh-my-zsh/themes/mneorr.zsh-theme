local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local user_host="%{$terminfo[bold]$fg[green]%}%n%{$fg[cyan]%}@%m%{$reset_color%}"
local current_dir="%{$terminfo[bold]$fg[green]%}%2c%{$reset_color%}"
local git_escaped='$(git_prompt_info)'
local green_arrow="%{$fg_bold[green]%}➜"

PROMPT="${git_escaped} ${green_arrow} "
RPS1="${return_code}"

RPROMPT="${current_dir}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
