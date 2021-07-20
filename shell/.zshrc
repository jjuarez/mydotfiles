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
                      'id_ed25519.github.com' \
                      'id_ed25519.gitlab.com'

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}
export DOTFILES="${HOME}/.mydotfiles"
export PATH=${DOTFILES}/bin:/usr/local/sbin:${PATH}

[[ "${HOME}/.bin" ]] && export PATH="${HOME}/.bin:${PATH}"

# zsh plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=lightgrey,bg=black"

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%)}:-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%)}:-%n}.zsh"
fi

# zsh theme
ZSH_THEME="powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[[ -L "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"

# Custom configurations
TOGGLES_VERBOSE=true
declare -A TOGGLES_CONFIGURATION=(
  [direnv]=true
  [fzf]=true
  [github]=true
  [go]=true
  [krew]=true
  [nodenv]=true
  [pyenv]=true
  [rbenv]=true
  [tfenv]=true
  [travis]=true
)

# Utilities and aliases
[[ -f "${DOTFILES}/shell/.togglesrc"   ]] && source "${DOTFILES}/shell/.togglesrc"
[[ -f "${DOTFILES}/shell/.functionsrc" ]] && source "${DOTFILES}/shell/.functionsrc"
[[ -f "${DOTFILES}/shell/.aliasesrc"   ]] && source "${DOTFILES}/shell/.aliasesrc"
