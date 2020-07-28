#set -u -o pipefail
#set -x

git::superlog() {
  git log \
    --graph \
    --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --height 100% --ansi --preview-window right:75% --preview "echo {}|grep -o '[a-f0-9]\{7\}'|head -1|xargs -I % sh -c 'git show --color=always %'" \
    --bind "enter:execute:
      (grep -o '[a-f0-9]\{7\}' | head -1 |
      xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
      {}
FZF-EOF"
}


git::squash_branch() {
  local -r current_branch_name=$(git rev-parse --abbrev-ref HEAD)
  local -r parent_commit=$(git merge-base master ${current_branch_name})

  cat<<EOF

  💣 Be careful this is a dangerous command, if you agree just follow these steps:

  Current branch name: ${current_branch_name}
  Branch parent commit: ${parent_commit}
  git reset ${parent_commit}
  git status
  git commit -am 'Squashed branch'
  git push origin ${current_branch_name} --force
EOF
}

# alias
alias gitsl='git::superlog'
alias gitsb='git::squash_branch'
