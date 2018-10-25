WORKSPACE="${HOME}/workspace"

[[ -d "${WORKSPACE}" ]] || exit 8

typeset -A directories
directories[mgmt]="${WORKSPACE}/fon/devops/infra/iac_mgmt"
directories[hw]="${WORKSPACE}/fon/devops/infra/iac_homewifi"
directories[live]="${WORKSPACE}/fon/devops/infra/iac_live"
directories[pc]="${WORKSPACE}/fon/devops/cm/puppet-control"
directories[pm]="${WORKSPACE}/fon/devops/cm/modules"
directories[ck8s]="${WORKSPACE}/fon/devops/infra/ck8s"
directories[backend]="${WORKSPACE}/fon/homeWiFi/services"
directories[misc]="${WORKSPACE}/fon/misc"
directories[src]="${WORKSPACE}/src"


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


aws::list_amis() {
  local profile=${1:-"default"}
  local configuration_file=${2:-"${HOME}/.aws_zsh_plugin.conf"}

  [[ -s "${configuration_file}" ]] || return 1

  source "${configuration_file}"

  aws --profile ${profile} ec2 describe-images --filters ${FILTERS} --owners ${OWNERS} --query 'Images[*].{ id:ImageId, name:Name, location:ImageLocation }'
}


##
# Get the bastion host
aws::get_bastion() {
declare -r DEFAULT_PROFILE="terraform"
declare -r DEFAULT_PARTNER="fon"
declare -r DEFAULT_SYSTEM="mgmt"
declare -r DEFAULT_ENV="pro"

  local profile=${1:-${DEFAULT_PROFILE}}
  local partner=${2:-${DEFAULT_PARTNER}}
  local system=${2:-${DEFAULT_SYSTEM}}
  local env=${3:-${DEFAULT_ENV}}

  local host_name="bastion-${partner}-${system}-${env}-001"

  BASTION=$(aws --profile ${profile} ec2 describe-instances --filter "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${host_name}" --query "Reservations[*].Instances[*].PublicDnsName" --output text)

  [[ -n "${BASTION}" ]] || return 1

  cat<<EOF

Host ${host_name}.fon.int
  HostName     ${BASTION}

EOF
}


##
# Load the k8s cluster configurations
declare -r DEFAULT_KUBECONFIG_DIRECTORY="${HOME}/.kube"
declare -r DEFAULT_KUBECONFIG_PATTERN="*.config"

k8s::load_configs() {
  local kubeconfig_pattern="*.config"
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
alias amis='aws::list_amis'
alias bastion='aws::get_bastion'
alias backup='${HOME}/.bin/backup.sh'
alias klc='k8s::load_configs'
alias k='/usr/local/bin/kubectl'

##
# Jumps
alias mgmt='fs::directories mgmt'
alias hw='fs::directories hw'
alias live='fs::directories live'
alias pc='fs::directories pc'
alias pm='fs::directories pm'
alias ck8s='fs::directories ck8s'
alias backend='fs::directories backend'
alias misc='fs::directories misc'
alias src='fs::directories src'
