#echo ">>> .zshrc"

ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(tmux rvm brew oh-my-zsh-bootstrap git git-flow sublime thor vagrant redis-cli docker go)
source "${ZSH}/oh-my-zsh.sh"

MYDOTFILES="${HOME}/.mydotfiles"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && source "${MYDOTFILES}/shell/shell.sh"

[ -f "${HOME}/.zprofile" ] && source "${HOME}/.zprofile"

[ -n "${BREW_HOME}" ] && eval "$(direnv hook ${SHELL})"
