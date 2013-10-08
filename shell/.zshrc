export MYDOTFILES=~/.mydotfiles
export ZSH=~/.oh-my-zsh
export ZSH_THEME="clean"
export CASE_SENSITIVE="true"
export DISABLE_AUTO_UPDATE="false"


[ -f ${ZSH}/oh-my-zsh.sh ] && . ${ZSH}/oh-my-zsh.sh

plugins=(git-flow heroku)

[ -f ${MYDOTFILES}/shell/shell.sh ] && source ${MYDOTFILES}/shell/shell.sh

[ -d /usr/local/heroku ] && PATH="/usr/local/heroku/bin:${PATH}"

[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm 

export PATH
