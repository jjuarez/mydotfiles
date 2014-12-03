# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Theme customization
ZSH_THEME="clean"

##
# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

##
# Plugins
plugins=(ssh-agent tmux brew git docker rbenv sublime tuenti)

. "${ZSH}/oh-my-zsh.sh"

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && . "${MYDOTFILES}/shell/shell.sh"

[ -x "${BREW_HOME}/bin/direnv" ] && eval "$(direnv hook ${SHELL})"

[ -f "${HOME}/.ssh/id_dsa" ] && ssh-add "${HOME}/.ssh/id_dsa" &>/dev/null

[ -s "${HOME}/.zprofile" ] && . "${HOME}/.zprofile"
