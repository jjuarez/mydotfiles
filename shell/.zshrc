export MYDOTFILES="${HOME}/.mydotfiles"
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(osx vim docker sublime tmux brew rvm gem svn git git-flow docker go go-lang thor vagrant knife redis-cli emoji-clock)
source "${ZSH}/oh-my-zsh.sh"
source "${HOME}/.zprofile"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && source "${MYDOTFILES}/shell/shell.sh"

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
