# .zshrc
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="clean"

##
# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

PATH=${PATH}:${HOME}/.bin

##
# Plugins
plugins=(ssh-agent aws)
. "${ZSH}/oh-my-zsh.sh"

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Setup for rbenv
[[ -d "${HOME}/.rbenv" ]] && {
  export PATH=${HOME}/.rbenv/bin:${PATH}
  eval "$(rbenv init -)"
}
