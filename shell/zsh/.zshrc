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
plugins=( ssh-agent brew git tmux go boot2docker sublime jira tuenti )
. "${ZSH}/oh-my-zsh.sh"

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"
TUENTI_PATHS=( /srv/scripts/tools /srv/scripts/monitoring /home/configcopy/configcopy/bin )

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

export PATH="${HOME}/.rbenv/bin:${PATH}"

eval "$(rbenv init -)"
