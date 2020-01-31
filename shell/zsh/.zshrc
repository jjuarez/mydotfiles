# .zshrc
ZSH="${HOME}/.oh-my-zsh"

# Custom flags
PYTHON_SUPPORT=1
RUBY_SUPPORT=0
JAVA_SUPPORT=0
TERRAGRUNT_SUPPORT=1
TERRAFORM_SUPPORT=1
K8S_SUPPORT=1
STARSHIP_SUPPORT=0

# Term customizations
TERM=xterm-256color
export LANG=en_US.UTF-8

[[ "${STARSHIP_SUPPORT}" -ne 1 ]] && {
  ZSH_THEME="powerlevel9k"

  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir kubecontext vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
  POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
}

# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
COMPLETION_WAITING_DOTS="false"

PATH=${PATH}:${HOME}/.bin

# kops & helm (you need this before to load the clarity plugin)
[[ -d "${HOME}/.helmenv" ]] && export PATH="${HOME}/.helmenv/bin:${PATH}"
[[ -d "${HOME}/.kopsenv" ]] && export PATH="${HOME}/.kopsenv/bin:${PATH}"

# Plugins
zstyle :omz:plugins:ssh-agent identities id_rsa.mundokids id_rsa id_rsa.clarity.ec2 id_rsa.ansible_provisioner_dev id_rsa.ansible_provisioner_pre id_rsa.ansible_provisioner_prod
plugins=(ssh-agent zsh-autosuggestions jira z clarity jjuarez)
. "${ZSH}/oh-my-zsh.sh"

# Some homebrew configuration
export GITHUB_HOMEBREW_TOKEN="7f462fbb75bf7b92986c17162c6f8d8eba572978"

# My own stuffs
MYDOTFILES="${HOME}/.mydotfiles"

[[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"

# Setup for fzf
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# Direnv
#eval "$(direnv hook zsh)"

# Setup for golang
[[ -s "${HOME}/.gorc" ]] && source "${HOME}/.gorc"

# Setup for rbenv
[[ "${RUBY_SUPPORT}" -eq 1 ]] && [[ -d "${HOME}/.rbenv/bin" ]] && {
  echo "Activating the ruby support..."

  export PATH=${HOME}/.rbenv/bin:${PATH}

  eval "$(rbenv init -)"
}

[[ "${PYTHON_SUPPORT}" -eq 1 ]] && [[ -d "${HOME}/.pyenv/bin" ]] && {
  echo "Activating the python support..."
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH=${PYENV_ROOT}/bin:${PATH}
  export CFLAGS="-O2 -I$(brew --prefix openssl)/include"
  export LDFLAGS="-L$(brew --prefix openssl)/lib"

  eval "$(pyenv init -)"
}

# Terragrunt & Terraform set up
if [ "${TERRAFORM_SUPPORT}" -eq 1 ]; then
  echo "Activating the terraform support..."

  [[ -d "${HOME}/.tfenv" ]] && export PATH="${HOME}/.tfenv/bin:${PATH}"

  [[ -d "${HOME}/.tgenv" ]] && {
    export PATH="${HOME}/.tgenv/bin:${PATH}"
    export TERRAGRUNT_TFPATH="${HOME}/.tfenv/bin/terraform"
  }
fi

# Java support
[[ "${JAVA_SUPPORT}" -eq 1 ]] && [[ -d "${HOME}/.sdkman" ]] && {
  echo "Activating the java support..."
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

# k8s support
if [ "${K8S_SUPPORT}" -eq 1 ]; then
  echo "Activating all the k8s stuff..."

  [[ -d "${HOME}/.krew" ]] && export PATH="$HOME/.krew/bin:${PATH}"

  if clarity::k8s_load_configs 2>/dev/null; then
    clarity::k8s_load_configs
  fi
fi

# MongoDB support
[[ -d "/Applications/MongoDB.app/Contents/Resources/Vendor/mongodb/bin" ]] && export PATH=${PATH}:/Applications/MongoDB.app/Contents/Resources/Vendor/mongodb/bin

# MySQL support
[[ -d "/usr/local/opt/mysql-client" ]] && export PATH=${PATH}:/usr/local/opt/mysql-client/bin

[[ "${STARSHIP_SUPPORT}" -eq 1 ]] && eval "$(starship init zsh)"

# ZSH options
setopt no_share_history
setopt autocd
setopt cdablevars
setopt correct
setopt histignoredups

# Testing new tools
alias diff="diff-so-fancy"
alias cat="bat"

# Shortcuts
shortcuts[k8s]=${WORKSPACE}/devops/infrastructure/kubernetes
shortcuts[helm]=${WORKSPACE}/devops/infrastructure/helm-charts
shortcuts[iac_live]=${WORKSPACE}/devops/infrastructure/terraform/iac_live
shortcuts[iac_root]=${WORKSPACE}/devops/infrastructure/terraform/iac_root
shortcuts[iac_mgmt]=${WORKSPACE}/devops/infrastructure/terraform/iac_mgmt
shortcuts[iac_saas]=${WORKSPACE}/devops/infrastructure/terraform/iac_saas

alias _k8s='clarity::shortcuts k8s'
alias _helm='clarity::shortcuts helm'
alias _iac_live='clarity::shortcuts iac_live'
alias _iac_root='clarity::shortcuts iac_root'
alias _iac_mgmt='clarity::shortcuts iac_mgmt'
alias _iac_saas='clarity::shortcuts iac_saas'

