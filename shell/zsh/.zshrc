# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Theme customization
ZSH_THEME="thejtoken"

##
# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

##
# Plugins
plugins=(ssh-agent git rbenv tuenti sublime)
. "${ZSH}/oh-my-zsh.sh"

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && source "${MYDOTFILES}/shell/shell.sh"

[ -f "${HOME}/.ssh/id_dsa" ] && ssh-add "${HOME}/.ssh/id_dsa" &>/dev/null

[ -s "${HOME}/.zprofile" ] && source "${HOME}/.zprofile"

[ -z "`which rbenv > /dev/null`" ] && eval "$(rbenv init -)"
