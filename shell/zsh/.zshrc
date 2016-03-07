# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Theme customization
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S %d/%m/%Y}"
POWERLEVEL9K_NODE_VERSION_BACKGROUND='022'
ZSH_THEME="powerlevel9k/powerlevel9k"

##
# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

unsetopt share_history

PATH=${PATH}:/usr/local/bin

##
# Plugins
plugins=(ssh-agent brew git mercurial go docker sublime jira tmux pyenv tuenti)
. "${ZSH}/oh-my-zsh.sh"

##
# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"
TUENTI_PATHS=( /srv/scripts/tools /srv/scripts/monitoring /home/configcopy/configcopy/bin )

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Setup for rbenv
export PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

# Setup for pyenv
export PATH=${HOME}/.pyenv/bin:${PATH}
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


