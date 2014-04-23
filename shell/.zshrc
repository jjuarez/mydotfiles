ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

[[ -z "${BREW_HOME}" ]] && {

  BREW_HOME="/usr/local"
  PATH=${PATH}:${BREW_HOME}/bin:${BREW_HOME}/sbin
}

plugins=(ssh-agent tmux brew git git-flow thor vagrant redis-cli docker rvm)
source "${ZSH}/oh-my-zsh.sh"

MYDOTFILES="${HOME}/.mydotfiles"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && source "${MYDOTFILES}/shell/shell.sh"

[ -x "${BREW_HOME}/bin/direnv" ] && eval "$(direnv hook ${SHELL})"

[ -f "${HOME}/.ssh/id_dsa.sysadmin" ] && ssh-add "${HOME}/.ssh/id_dsa.sysadmin" &>/dev/null

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
