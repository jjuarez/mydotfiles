# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim}
# }}} End configuration added by Zim install

[[ -f "${HOME}/.zshenv.local" ]] && source "${HOME}/.zshenv.local"

fpath=(
  /usr/local/share/zsh/site-functions
  ${DOTFILES}/shell/functions
  ${fpath}
)

# General User environment
export EDITOR='vim'
export TERM="xterm-256color"
