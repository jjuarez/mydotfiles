# .zshrc
ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM=${HOME}/.customizations
ZSH_THEME="thejtoken"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(ssh-agent screen git)
source "${ZSH}/oh-my-zsh.sh"

MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

[[ -x "${BREW_HOME}/bin/direnv" ]] && eval "$(direnv hook ${SHELL})"

[[ -f "${HOME}/.ssh/id_rsa.tuenti.sysadmin" ]] && ssh-add "${HOME}/.ssh/id_rsa.tuenti.sysadmin" &>/dev/null

[[ -s "${HOME}/.zprofile" ]] && source "${HOME}/.zprofile"
