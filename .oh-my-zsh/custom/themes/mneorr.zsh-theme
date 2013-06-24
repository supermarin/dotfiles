local current_dir="%2c%{$reset_color%}"
local git_escaped='$(git_prompt_info)'
local green_arrow="%{$fg_bold[green]%}➜"

PROMPT="${git_escaped} ${green_arrow} "
RPROMPT="${current_dir}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
