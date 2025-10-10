# ZSH Profiling BEGIN
zmodload zsh/zprof

# SSH keys to load by the agent
zstyle ':zim:ssh' ids 'id_rsa.github.ibm.com' \
                      'id_ed25519.github.com'

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

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}
[[ "${HOME}/.homebrewrc" ]] && source "${HOME}/.homebrewrc"

export DOTFILES="${HOME}/.mydotfiles"

[[ -d "${HOME}/.bin"       ]] && export PATH=${HOME}/.bin:${PATH}
[[ -d "${HOME}/.local/bin" ]] && export PATH=${HOME}/.local/bin:${PATH}

export PATH=/usr/local/sbin:${PATH}

# Custom configurations
FEATURES_VERBOSE=true
declare -A FEATURES_CONFIGURATION=(
  [artifactory]=true
  [atuin]=true
  [direnv]=true
  [fzf]=true
  [git]=true
  [ghe]=true
  [github]=true
  [go]=false
  [ibmcloud]=true
  [krew]=true
  [python]=true
  [rust]=false
  [terraform]=true
  [tfenv]=true
  [volta]=false
  [zoxide]=true
)

[[ -f "${HOME}/.featuresrc" ]] && source "${HOME}/.featuresrc"

# zsh plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=lightgrey,bg=black"

# themes
ZSH_THEME="powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

[[ -L "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"

# Utilities and aliases
[[ -f "${HOME}/.aliasesrc" ]] && source "${HOME}/.aliasesrc"

# ZSH Profiling END
zprof
