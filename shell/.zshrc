ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="thejtoken"

CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(ssh-agent screen tmux brew git git-flow thor vagrant redis-cli docker rbenv sublime)
source "${ZSH}/oh-my-zsh.sh"

MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

[[ -x "${BREW_HOME}/bin/direnv"      ]] && eval "$(direnv hook ${SHELL})"

[[ -f "${HOME}/.ssh/id_dsa.tuenti"   ]] && ssh-add "${HOME}/.ssh/id_dsa.tuenti" &>/dev/null

[[ -s "${HOME}/.zprofile"            ]] && source "${HOME}/.zprofile"
