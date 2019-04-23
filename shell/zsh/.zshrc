# .zshrc
ZSH="${HOME}/.oh-my-zsh"

# Term customizations
TERM=xterm-256color

ZSH_THEME="powerlevel9k"

# Theme customization
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir kubecontext pyenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
#POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

PATH=${PATH}:${HOME}/.bin

# Plugins
# plugins=(ssh-agent git brew docker aws terraform kubectl helm jira zsh-syntax-highlighting zsh-autosuggestions jjuarez)
#plugins=(ssh-agent git brew docker aws terraform helm jjuarez zsh-syntax-highlighting zsh-autosuggestions)
plugins=(ssh-agent git brew docker aws terraform helm jira jjuarez)
. "${ZSH}/oh-my-zsh.sh"

# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Some homebrew configuration
export GITHUB_HOMEBREW_TOKEN="e0f12273063596b0bfa523008b3d6bcf4147f112"

# Setup for fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Setup for rbenv
[[ -d "${HOME}/.rbenv/bin" ]] && {
  export PATH=${HOME}/.rbenv/bin:${PATH}

  eval "$(rbenv init -)"
}

[[ -d "${HOME}/.pyenv/bin" ]] && {
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH=${PYENV_ROOT}/bin:${PATH}
  export CFLAGS="-O2 -I$(brew --prefix openssl)/include"
  export LDFLAGS="-L$(brew --prefix openssl)/lib"

  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
}

# Setup for golang
[[ -s "${HOME}/.gorc" ]] && source "${HOME}/.gorc"

# Terraform/Terragrunt setup
[[ -d "${HOME}/.terragrunt/cache" ]] || mkdir -p "${HOME}/.terragrunt/cache"
export TERRAGRUNT_DOWNLOAD="${HOME}/.terragrunt/cache"

[[ -d "${HOME}/.tfenv" ]] && export PATH="${HOME}/.tfenv/bin:$PATH"
[[ -x "${HOME}/.tfenv/bin/terraform" ]] && export TERRAGRUNT_TFPATH="${HOME}/.tfenv/bin/terraform"

# Krew support
[[ -d "${HOME}/.krew" ]] && export PATH="$HOME/.krew/bin:$PATH"

# Load always all the k8s contexts
if k8s::load_configs 2>/dev/null; then
  k8s::load_configs
fi

# To avoid shared history
setopt no_share_history
