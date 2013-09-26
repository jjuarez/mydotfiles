export MYDOTFILES=~/.mydotfiles
export ZSH=~/.oh-my-zsh
export ZSH_THEME="thejtoken"
export CASE_SENSITIVE="true"
export DISABLE_AUTO_UPDATE="false"

alias rvm-prompt=$HOME/.rvm/bin/rvm-prompt


[ -f ${ZSH}/oh-my-zsh.sh ] && . ${ZSH}/oh-my-zsh.sh

plugins=(brew git-flow rvm bundler vagrant gem knife heroku)

[ -f ${MYDOTFILES}/shell/shell.sh ] && . ${MYDOTFILES}/shell/shell.sh

[ -d /usr/local/heroku ] && PATH="/usr/local/heroku/bin:${PATH}"

[ -f ${HOME}/.rvm/scripts/rvm ] && {

  . ${HOME}/.rvm/scripts/rvm
  PATH=${HOME}/.rvm/bin:${PATH}
}

export PATH

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
