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

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
