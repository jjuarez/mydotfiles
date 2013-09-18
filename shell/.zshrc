export MYDOTFILES=~/.mydotfiles
export ZSH=~/.oh-my-zsh
export ZSH_THEME="thejtoken"
export CASE_SENSITIVE="true"
export DISABLE_AUTO_UPDATE="false"

alias rvm-prompt=$HOME/.rvm/bin/rvm-prompt

[ -f "${ZSH}/oh-my-zsh.sh" ] && . "${ZSH}/oh-my-zsh.sh"

plugins=(brew git-flow rvm bundler vagrant gem knife heroku)

[ -f "${MYDOTFILES}/shell/shell.sh" ] && . "${MYDOTFILES}/shell/shell.sh"

[ -s "${HOME}/.rvm/scripts/rvm"     ] && . "${HOME}/.rvm/scripts/rvm" 

export PATH=${HOME}/.rvm/bin:${PATH}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
