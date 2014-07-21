export PATH="${HOME}/.rbenv/bin:${PATH}"
export PATH="${HOME}/.rbenv/shims:${PATH}"
source "/usr/local/Cellar/rbenv/0.4.0/libexec/../completions/rbenv.zsh"

rbenv rehash 2>/dev/null

rbenv() {

  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
    rehash|shell)
      eval `rbenv "sh-$command" "$@"`
      ;;
    *)
      command rbenv "$command" "$@"
      ;;
  esac
}
