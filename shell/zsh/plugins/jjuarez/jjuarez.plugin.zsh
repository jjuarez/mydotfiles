WORKSPACE="${HOME}/workspace"
CORP="clarity"

[[ -d "${WORKSPACE}" ]] || exit 8

typeset -A directories
directories[live]="${WORKSPACE}/${CORP}/devops/infra/clarity_live"
directories[mgmt]="${WORKSPACE}/${CORP}/devops/infra/iac_mgmt"
directories[clarity]="${WORKSPACE}/${CORP}/devops/infra/clarity_modules"
#directories[pc]="${WORKSPACE}/${CORP}/devops/cm/puppet-control"
#directories[pm]="${WORKSPACE}/${CORP}/devops/cm/modules"


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
declare -r DEFAULT_KUBECONFIG_PATTERN="*.config"
declare -r DEFAULT_KUBECONFIG_DIRECTORY="${HOME}/.kube"

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
alias archive='fs::archive'
alias git_fshow='git::fshow'
alias backup='${HOME}/.bin/backup.sh'
alias loadkubeconfs='k8s::load_configs'

##
# Jumps
alias live='fs::directories live'
alias mgmt='fs::directories mgmt'
alias clarity='fs::directories clarity'
#alias pc='fs::directories pc'
#alias pm='fs::directories pm'
