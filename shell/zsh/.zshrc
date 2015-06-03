# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Theme customization
ZSH_THEME="powerlevel9k/powerlevel9k"

##
# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

##
# Plugins
plugins=(ssh-agent brew git rbenv tuenti sublime tmux)
. "${ZSH}/oh-my-zsh.sh"

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[ -f "${MYDOTFILES}/shell/shell.sh" ] && source "${MYDOTFILES}/shell/shell.sh"

[ -s "${HOME}/.zprofile" ] && source "${HOME}/.zprofile"

[ -z "`which rbenv > /dev/null`" ] && eval "$(rbenv init -)"
