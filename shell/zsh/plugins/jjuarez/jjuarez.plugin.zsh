##
# Functions
fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 7

  tar -czf ${directory}{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}


typeset -A directories
directories[mgmt]="${HOME}/workspace/fon/devops/infra/iac_mgmt"
directories[homewifi]="${HOME}/workspace/fon/devops/infra/iac_homewifi"
directories[live]="${HOME}/workspace/fon/devops/infra/iac_live"
directories[pc]="${HOME}/workspace/fon/devops/cm/puppet-control"

fs::directories() {
  local dir=${1}

  case ${dir} in
   homewifi| mgmt|live|pc)
      [[ -d "${directories[$dir]}" ]] && cd "${directories[$dir]}"
    ;;
    *)
      return 1
    ;;
  esac
}


aws::list_amis() {
  local profile=${1:-"default"}
  local configuration_file=${2:-"${HOME}/.aws_zsh_plugin.conf"}

  [[ -s "${configuration_file}" ]] || return 1

  source "${configuration_file}"

  aws --profile ${profile} ec2 describe-images --filters ${FILTERS} --owners ${OWNERS} --query 'Images[*].{ id:ImageId, name:Name, location:ImageLocation }'
}


declare -r DEFAULT_PROFILE="terraform"
declare -r DEFAULT_PARTNER="Fon"
declare -r DEFAULT_SYSTEM="mgmt"
declare -r DEFAULT_ENV="pro"

##
# Get the bastion host
aws::get_bastion() {
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


git::fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always %'" \
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
alias mgmt='fs::directories mgmt'
alias homewifi='fs::directories homewifi'
alias live='fs::directories live'
alias pc='fs::directories pc'
