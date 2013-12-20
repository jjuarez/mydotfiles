export MYDOTFILES=~/.mydotfiles
ZSH=~/.oh-my-zsh
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(osx vim brew rvm svn git bundler vagrant)
. ${ZSH}/oh-my-zsh.sh

[ -f ${MYDOTFILES}/shell/shell.sh ] && . ${MYDOTFILES}/shell/shell.sh

[ -d /usr/local/heroku ] && export PATH="/usr/local/heroku/bin:${PATH}"

[ -s ${HOME}/.rvm/scripts/rvm ] && { 

  . ${HOME}/.rvm/scripts/rvm
  export PATH=${HOME}/.rvm/bin:${PATH}
}
