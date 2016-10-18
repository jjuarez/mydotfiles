# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Theme customization
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
ZSH_THEME="powerlevel9k"

##
# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

PATH=${PATH}:/usr/local/bin

##
# Plugins
plugins=(ssh-agent brew git go docker sublime jjuarez)
. "${ZSH}/oh-my-zsh.sh"

# To avoid shared history
#unsetopt share_history Off

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"
TUENTI_PATHS=(/srv/scripts/tools /srv/scripts/monitoring /home/configcopy/configcopy/bin )

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Setup for rbenv
export PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

