#
# This is a workaround sice the official plugin for zim is not working at all for me
#
ssh::load_keys() {
  zstyle -a ':zim:ssh' ids 'zssh_ids'

  if (( ${#zssh_ids} )); then
    ssh-add -q ${HOME}/.ssh/${^zssh_ids}
  else
    ssh-add 2>/dev/null
  fi
}
