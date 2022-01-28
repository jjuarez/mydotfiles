ssh::load_keys() {
  local -a zssh_ids

  zstyle -a ':zim:ssh' ids 'zssh_ids'

  if (( ${#zssh_ids} )); then
    ssh-add -q ${HOME}/.ssh/${^zssh_ids} 2>/dev/null
  else
    ssh-add 2>/dev/null
  fi
}

# autoloads
autoload ssh::load_keys

# aliases
alias sshlk='ssh::load_keys'
