# .zshrc
ZSH="${HOME}/.oh-my-zsh"

# Term customizations
TERM=xterm-256color
export LANG=en_US.UTF-8

ZSH_THEME="powerlevel9k"

# Theme customization
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir kubecontext vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="true"

PATH=${PATH}:${HOME}/.bin

# kops & helm (you need this before to load the clarity plugin)
[[ -d "${HOME}/.helmenv" ]] && export PATH="${HOME}/.helmenv/bin:${PATH}"
[[ -d "${HOME}/.kopsenv" ]] && export PATH="${HOME}/.kopsenv/bin:${PATH}"

# Plugins
zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa.clarity.ec2 id_rsa.ansible_provisioner_dev id_rsa.ansible_provisioner_pre id_rsa.ansible_provisioner_prod
plugins=(ssh-agent zsh-autosuggestions kubectl kops helm jira jjuarez clarity)
. "${ZSH}/oh-my-zsh.sh"

# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Some homebrew configuration
export GITHUB_HOMEBREW_TOKEN="e0f12273063596b0bfa523008b3d6bcf4147f112"

# Setup for fzf
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# Setup for golang
[[ -s "${HOME}/.gorc" ]] && source "${HOME}/.gorc"

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
}

# Terraform/Terragrunt setup
[[ -d "${HOME}/.tfenv" ]] && {
   export PATH="${HOME}/.tfenv/bin:${PATH}"
   export TERRAGRUNT_TFPATH="${HOME}/.tfenv/bin/terraform"
}

[[ -d "${HOME}/.terragrunt/cache" ]] || mkdir -p "${HOME}/.terragrunt/cache"
#export TERRAGRUNT_DOWNLOAD="${HOME}/.terragrunt/cache"

# Krew support
[[ -d "${HOME}/.krew" ]] && export PATH="$HOME/.krew/bin:${PATH}"

# Java support
[[ -d "${HOME}/.sdkman" ]] && { 
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

# Load always all the k8s contexts
if clarity::k8s_load_configs 2>/dev/null; then
  echo "Loading kubernetes configurations..."
  clarity::k8s_load_configs

# echo "Switching to the development cluster..."
# clarity::k8s_switch dev
fi

# To avoid shared history
setopt no_share_history

# ZSH options
setopt autocd
setopt cdablevars
setopt correct
setopt histignoredups

