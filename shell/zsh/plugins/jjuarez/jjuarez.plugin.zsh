declare -r CORP="clarity"
declare -r WORKSPACE="${HOME}/workspace/${CORP}"

[[ -d "${WORKSPACE}" ]] || return 1

declare -A directories
directories[product]="${WORKSPACE}/product"
directories[front]="${WORKSPACE}/product/frontend"
directories[back]="${WORKSPACE}/product/backend"
directories[needs]="${WORKSPACE}/product/needs"
directories[infra]="${WORKSPACE}/devops/infrastructure"
directories[cm]="${WORKSPACE}/devops/cm/ansible"
directories[citools]="${WORKSPACE}/devops/infrastructure/ci-tools"
directories[helm]="${WORKSPACE}/devops/infrastructure/helm-charts"


fs::shortcut() {
  local dir=${1}

  [[ -d "${directories[$dir]}" ]] && cd "${directories[$dir]}"
}


fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 7

  tar -czf ${directory}{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}


##
# Load the k8s cluster configurations
DEFAULT_KUBECONFIG_PATTERN="*.config"
DEFAULT_KUBECONFIG_DIRECTORY="${HOME}/.kube"

k8s::load_configs() {
  local kubeconfig_pattern="${1:-${DEFAULT_KUBECONFIG_PATTERN}}"
  local kubeconfig_directory="${2:-${DEFAULT_KUBECONFIG_DIRECTORY}}"

  [[ -d "${kubeconfig_directory}" ]] || return 1

  export KUBECONFIG=$(find ${kubeconfig_directory} -type f -name "${kubeconfig_pattern}" -print|tr '\n' ':'|sed -e 's/:$//g')
}


##
# Iteractive log
git::fshow() {
  git log --graph \
          --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --preview "echo {}|grep -o '[a-f0-9]\{7\}'|head -1|xargs -I % sh -c 'git show --color=always %'" \
             --bind "enter:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}


##
# Aliases
# utils
alias archive='fs::archive'
alias git_fshow='git::fshow'
alias backup='${HOME}/.bin/backup.sh'
# k8s
alias klc='k8s::load_configs'
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
# Shortcuts
alias _infra='fs::shortcut infra'
alias _cm='fs::shortcut cm'
alias _product='fs::shortcut product'
alias _front='fs::shortcut front'
alias _back='fs::shortcut back'
alias _needs='fs::shortcut needs'
alias _citools='fs::shortcut citools'
alias _helm='fs::shortcut helm'
# Sites
alias _issues='open_command https://gitlab.clarity.ai/infrastructure/issues/issues'
alias _aws='open_command https://console.aws.amazon.com/console/home'
alias _calendar='open_command https://calendar.google.com'
