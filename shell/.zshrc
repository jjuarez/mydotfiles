# Start configuration added by Zim install {{{
# zimfw configuration
export HISTFILE="${HOME}/.zsh_history"  # Try to share the shell history across subshells
bindkey -e
setopt CORRECT

WORDCHARS=${WORDCHARS//[\/]}
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZIM_HOME="${HOME}/.zim"

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

source ${ZIM_HOME}/init.zsh
zmodload -F zsh/terminfo +p:terminfo
# }}} End configuration added by Zim install

# SSH keys to load by the agent
zstyle ':zim:ssh' ids 'id_ed25519.github.ibm.com' \
                      'id_ed25519.github.com'

export HOMEBREW_NO_AUTO_UPDATE=1
export DOTFILES="${HOME}/.mydotfiles"
export PATH=${DOTFILES}/bin:$(brew --prefix)/sbin:${PATH}

# Custom configurations
TOGGLES_VERBOSE=true
declare -A TOGGLES_CONFIGURATION=(
  [direnv]=true
  [fzf]=true
  [github]=true
  [travis]=false
  [go]=true
  [nodenv]=true
  [pyenv]=false
  [rbenv]=false
  [tfenv]=false
)
[[ -L "${HOME}/.togglesrc" ]] && source "${HOME}/.togglesrc"

# Utilities and aliases
[[ -L "${HOME}/.zfunctionsrc" ]] && source "${HOME}/.zfunctionsrc"
[[ -L "${HOME}/.aliasesrc" ]] && source "${HOME}/.aliasesrc"

# zsh plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=lightgrey,bg=black"

# zsh theme
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
ZSH_THEME="powerlevel10k"
[[ -L "${HOME}/.p10krc" ]] && source "${HOME}/.p10krc"
