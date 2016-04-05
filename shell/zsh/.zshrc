# .zshrc
ZSH="${HOME}/.oh-my-zsh"

##
# Theme customization
POWERLINE_SHORT_HOST_NAME="true"
POWERLINE_PATH="short"
POWERLINE_GIT_DIRTY="💩"
ZSH_THEME="powerline"

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
TUENTI_PATHS=(/srv/scripts/tools /srv/scripts/monitoring /home/configcopy/configcopy/bin )

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Setup for rbenv
export PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

# Setup for pyenv
export PATH=${HOME}/.pyenv/bin:${PATH}
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


