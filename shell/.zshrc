export MYDOTFILES="${HOME}/.mydotfiles"
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(osx vim brew rvm svn git bundler vagrant)
. "${ZSH}/oh-my-zsh.sh"
. "${HOME}/.zprofile"

[ -f ${MYDOTFILES}/shell/shell.sh ] && . ${MYDOTFILES}/shell/shell.sh

[ -d "${HOME}/.rvm/bin" ] && export PATH=${HOME}/.rvm/bin:${PATH}
