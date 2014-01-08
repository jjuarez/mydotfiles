export MYDOTFILES="${HOME}/.mydotfiles"
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(osx vim sublime tmux brew rvm gem svn git git-flow docker go go-lang bundler thor vagrant knife redis-cli emoji-clock)
. "${ZSH}/oh-my-zsh.sh"
. "${HOME}/.zprofile"

[ -f ${MYDOTFILES}/shell/shell.sh ] && . ${MYDOTFILES}/shell/shell.sh

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
