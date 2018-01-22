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

aws::list_bastions() {
  local profile=${1:-"default"}
  local env=${2:-"pro"}

  aws --profile ${profile} ec2 describe-instances --filter "Name=tag:Name,Values=bastion-${env}-*" --query 'Reservations[*].Instances[*].NetworkInterfaces[0].Association.PublicIp'
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
alias bastions='aws::list_bastions'
alias git_fshow='git::fshow'

