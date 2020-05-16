# zsh cache configuration

#set -e -o pipefail

ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM=${ZSH}/custom
ZSH_CACHE_DIR="${HOME}/.zsh_cache"

[[ -d "${ZSH_CACHE_DIR}" ]] || mkdir -p "${ZSH_CACHE_DIR}"

# Feature flags
declare -A FTS=(
  [fzf]=true
  [direnv]=false
  [k8s]=true
  [tf]=true
  [python]=true
  [ruby]=false
  [java]=false
  [github]=true
)

# Term customizations
TERM=xterm-256color
export LANG=en_US.UTF-8

# Theme
ZSH_THEME="powerlevel9k"
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir aws kubecontext vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# ZSH Options
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="false"

# Custom, kops & helm (you need this before to load the clarity plugin)
[[ -d "${HOME}/.bin"     ]] && PATH="${PATH}:${HOME}/.bin"
[[ -d "${HOME}/.helmenv" ]] && export PATH="${HOME}/.helmenv/bin:${PATH}"
[[ -d "${HOME}/.kopsenv" ]] && export PATH="${HOME}/.kopsenv/bin:${PATH}"

# Plugins
zstyle :omz:plugins:ssh-agent identities id_rsa.pi id_rsa.mundokids id_rsa id_rsa.clarity.ec2 id_rsa.ansible_provisioner_dev id_rsa.ansible_provisioner_pre id_rsa.ansible_provisioner_prod id_rsa.ansible_provisioner_mgmt id_rsa.mgmt_k8s
plugins=(ssh-agent zsh-autosuggestions z jira kubectl clarity jjuarez)

source "${ZSH}/oh-my-zsh.sh"

##
## My own zsh stuff
##
if [ -d "${HOME}/.mydotfiles" ]; then
  export PATH=${PATH}:/usr/local/sbin
  export MYDOTFILES="${HOME}/.mydotfiles"

  [[ -f "${MYDOTFILES}/shell/shell.sh" ]] && source "${MYDOTFILES}/shell/shell.sh"
fi


##
## Optional Features
##
ft::fzf() {
  [[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"
}

ft::direnv() {
  [[ -x "$(brew --prefix)/bin/direnv" ]] && eval "$(direnv hook zsh)"
}

ft::k8s() {
  if whence -w clarity::k8s_load_kubeconfig 2>&1 >/dev/null; then
    clarity::k8s_load_kubeconfig # Forces the load of all the kubeconfig files
  fi

  [[ -d "${HOME}/.krew" ]] && export PATH="${HOME}/.krew/bin:${PATH}"
}

ft::tf() {
  [[ -d "${HOME}/.tfenv" ]] && export PATH="${HOME}/.tfenv/bin:${PATH}"

  [[ -d "${HOME}/.tgenv" ]] && {
    export PATH="${HOME}/.tgenv/bin:${PATH}"
    export TERRAGRUNT_TFPATH="${HOME}/.tfenv/bin/terraform"
  }
}

ft::python() {
  [[ -d "${HOME}/.pyenv/bin" ]] && {
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH=${PYENV_ROOT}/bin:${PATH}
    export CFLAGS="-O2 -I$(brew --prefix openssl)/include"
    export LDFLAGS="-L$(brew --prefix openssl)/lib"

    eval "$(pyenv init -)"
  }
}

ft::ruby() {
  [[ -d "${HOME}/.rbenv/bin" ]] && {
    export PATH=${HOME}/.rbenv/bin:${PATH}

    eval "$(rbenv init -)"
  }
}

ft::java() {
  [[ -d "${HOME}/.sdkman" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
}

ft::github() {
  [[ -d "${HOME}/.githubrc" ]] && source "${HOME}/.githubrc"
}

echo -en "Features: "
for feature activated in ${(kv)FTS}; do
  if [ "${activated}" = true ]; then
    echo -en "${feature} "
    ft::${feature}
  fi
done
echo -en "\n"


##
## Non optional features
##

# Golang support
ft::go() {
  [[ -s "${HOME}/.gorc" ]] && source "${HOME}/.gorc"
}

# MongoDB support
MONGODB_PATH="/Applications/MongoDB.app/Contents/Resources/Vendor/mongodb/bin"

[[ -d "${MONGODB_PATH}" ]] && export PATH=${PATH}:${MONGODB_PATH}

# MySQL support
MYSQL_PATH="$(brew --prefix)/opt/mysql-client/bin"

[[ -d "${MYSQL_PATH}" ]] && {
  export PATH=${PATH}:${MYSQL_PATH}
  export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
  export CPPFLAGS="-I/usr/local/opt/mysql-client/include"
  export PKG_CONFIG_PATH="/usr/local/opt/mysql-client/lib/pkgconfig"
}


##
## Pure zsh options
##
setopt no_share_history
setopt histignoredups
setopt cdablevars
setopt correct
setopt autocd
cdpath=(
  "${HOME}/workspace/clarity/infrastructure"
  "${HOME}/workspace/clarity/product"
  "${HOME}/workspace/clarity/documentation"
)


##
## Alternative tools
##
alias diff="diff-so-fancy"
alias cat="bat"
