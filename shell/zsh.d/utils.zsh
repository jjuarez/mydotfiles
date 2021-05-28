utils::multi_source() {
  local -r files="${@}"

  for f in $(echo ${files}|tr ' ' '\n'); do
    [[ -f "${f}" ]] && source "${f}"
  done
}

# autoloads
autoload utils::multi_source

# aliases
alias msource='utils::multi_source'
alias jsontidy='pbpaste|jq '.'|pbcopy'
