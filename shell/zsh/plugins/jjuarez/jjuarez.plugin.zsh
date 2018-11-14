WORKSPACE="${HOME}/workspace"

[[ -d "${WORKSPACE}" ]] || exit 8

typeset -A directories
directories[mgmt]="${WORKSPACE}/fon/devops/infra/iac_mgmt"
directories[hw]="${WORKSPACE}/fon/devops/infra/iac_homewifi"
directories[live]="${WORKSPACE}/fon/devops/infra/iac_live"
directories[pc]="${WORKSPACE}/fon/devops/cm/puppet-control"
directories[pm]="${WORKSPACE}/fon/devops/cm/modules"
directories[ck8s]="${WORKSPACE}/fon/devops/infra/ck8s"


##
# Functions
fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 7

  tar -czf ${directory}{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}


fs::directories() {
  local dir=${1}

  [[ -d "${directories[$dir]}" ]] && cd "${directories[$dir]}"
}


##
# Load the k8s cluster configurations
declare -r DEFAULT_KUBECONFIG_DIRECTORY="${HOME}/.kube"
declare -r DEFAULT_KUBECONFIG_PATTERN="*.config"

k8s::load_configs() {
  local kubeconfig_pattern="*-config"
  local kubeconfig_directory="${HOME}/.kube"

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
alias archive='fs::archive'
alias git_fshow='git::fshow'
alias backup='${HOME}/.bin/backup.sh'
alias loadkc='k8s::load_configs'

##
# Jumps
alias mgmt='fs::directories mgmt'
alias hw='fs::directories hw'
alias live='fs::directories live'
alias pc='fs::directories pc'
alias pm='fs::directories pm'
alias ck8s='fs::directories ck8s'
