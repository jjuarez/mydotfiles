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

# alias
alias git_fshow='git::fshow'
