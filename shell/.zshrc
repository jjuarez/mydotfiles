export MYDOTFILES=~/.mydotfiles
export ZSH=~/.oh-my-zsh
export ZSH_THEME="clean"

source ${ZSH}/oh-my-zsh.sh

plugins=(bunder gem brew git git-flow heroku)

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"

[ -f ${MYDOTFILES}/shell/shell.sh ] && source ${MYDOTFILES}/shell/shell.sh

[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm 

[ -d /usr/local/heroku ] && export PATH="/usr/local/heroku/bin:${PATH}"
