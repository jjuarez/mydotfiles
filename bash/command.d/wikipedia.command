wiki() {
  [ -n "${1}" ] && /usr/bin/dig +short txt ${1}.wp.dg.cx
}
