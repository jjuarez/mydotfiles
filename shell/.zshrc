export MYDOTFILES=~/.mydotfiles
ZSH=~/.oh-my-zsh
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(osx vim brew rvm svn git bundler vagrant)
source ${ZSH}/oh-my-zsh.sh

[ -f ${MYDOTFILES}/shell/shell.sh ] && source ${MYDOTFILES}/shell/shell.sh

[ -d /usr/local/heroku ] && export PATH="/usr/local/heroku/bin:${PATH}"

[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
