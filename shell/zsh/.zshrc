# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Term customizations
TERM=xterm-256color

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
# Jira plugin options
JIRA_URL=https://4iqnet.atlassian.net/
JIRA_PREFIX=
JIRA_NAME="Javier Juarez"
JIRA_RAPID_BOARD=27
JIRA_DEFAULT_ACTION=new

##
# Plugins
plugins=(ssh-agent brew git docker sublime aws jjuarez)
. "${ZSH}/oh-my-zsh.sh"

# To avoid shared history
#unsetopt share_history Off

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Setup for rbenv
export PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

