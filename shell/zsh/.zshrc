# .zshrc
ZSH="${HOME}/.oh-my-zsh"

# Term customizations
TERM=xterm-256color

# Theme customization
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir aws rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=4
POWERLEVEL9K_SHORTEN_DELIMITER="···"
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
ZSH_THEME="powerlevel9k"

# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

PATH=${PATH}:${HOME}/.bin

# Plugins
plugins=(ssh-agent git bundler brew docker aws terraform kubectl helm jira jjuarez zsh-syntax-highlighting)
. "${ZSH}/oh-my-zsh.sh"

# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Some homebrew configuration
export GITHUB_HOMEBREW_TOKEN="e0f12273063596b0bfa523008b3d6bcf4147f112"

# Setup for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setup for rbenv
[[ -d "${HOME}/.rbenv" ]] && {
  export PATH=${HOME}/.rbenv/bin:${PATH}
  eval "$(rbenv init -)"
}

# Setup for golang
[[ -s "${HOME}/.gorc" ]] && {
  source "${HOME}/.gorc"
}

# To avoid shared history
setopt no_share_history
