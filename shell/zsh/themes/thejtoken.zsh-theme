# Based on clean.theme
PROMPT='%{$fg[white]%}%B%n@%m%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%}%{$fg[yellow]%}[$(rvm-prompt)]%{$reset_color%}:$(git_prompt_info)%(!.#.$) '
# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗"
