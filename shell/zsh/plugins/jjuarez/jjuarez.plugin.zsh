##
# Functions
fs::archive() {
  local directory="${1}"

  [[ -d "${directory}" ]] || return 7

  tar -czf ${directory}{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}


aws::list_amis() {
  local configuration_file=${1:-"${HOME}/.aws_zsh_plugin.conf"}

  [[ -s "${configuration_file}" ]] || return 1

  source "${configuration_file}"
  aws ec2 describe-images --owners ${owner} | jq '.Images[] | { name: .Name, id: .ImageId }'
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
alias lamis='aws::list_amis'
alias archive='fs::archive'
alias gitfshow='git::fshow'

