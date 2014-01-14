export MYDOTFILES="${HOME}/.mydotfiles"
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(osx tmux brew oh-my-zsh-bootstrap git git-flow sublime thor vagrant knife redis-cli docker go)
source "${ZSH}/oh-my-zsh.sh"
source "${HOME}/.zprofile"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && source "${MYDOTFILES}/shell/shell.sh"

PATH=${HOME}/.rvm/bin:${PATH}
eval "$(direnv hook ${SHELL})"
