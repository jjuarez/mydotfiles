##
# Functions
fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 7

  tar -czf ${directory}{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}


aws::list_amis() {
  local profile=${1:-"default"}
  local configuration_file=${2:-"${HOME}/.aws_zsh_plugin.conf"}

  [[ -s "${configuration_file}" ]] || return 1

  source "${configuration_file}"

  aws --profile ${profile} ec2 describe-images --filters ${FILTERS} --owners ${OWNERS} --query 'Images[*].{ id:ImageId, name:Name, location:ImageLocation }'
}


declare -r DEFAULT_PROFILE="homewifi_terraform"
declare -r DEFAULT_ENV="pro"

##
# Get the bastion host
aws::get_bastion() {
  local profile=${1:-${DEFAULT_PROFILE}}
  local env=${2:-${DEFAULT_ENV}}
  local host_name="bastion-${env}-001"

  BASTION=$(aws --profile ${profile} ec2 describe-instances --filter "Name=tag:Name,Values=${host_name}" --query 'Reservations[0].Instances[0].PublicDnsName'|sed -e 's/"//g')

  [[ -n "${BASTION}" ]] || return 1

  cat<<EOF

Host ${host_name}
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
alias amis='aws::list_amis'
alias bastion='aws::get_bastion'
alias git_fshow='git::fshow'
