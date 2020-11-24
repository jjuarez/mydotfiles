ssh::load_keys() {
  zstyle -a ':zim:ssh' ids 'zssh_ids'

  if (( ${#zssh_ids} )); then
    ssh-add -q ${HOME}/.ssh/${^zssh_ids}
  else
    ssh-add 2>/dev/null
  fi
}

alias sshlk='ssh::load_keys'
