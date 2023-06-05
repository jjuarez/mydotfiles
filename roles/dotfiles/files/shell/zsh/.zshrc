# SSH keys to load by the agent
zstyle ':zim:ssh' ids 'id_ed25519.github.com' \
                      'id_ed25519.github.ibm.com' \
                      'id_ed25519.snips.sh' \
                      'id_rsa.ibm.runtimedeployusr.qnet' \
                      'id_rsa.ibm.runtimedeployusr.openq' \
                      'id_rsa.ibm.runtimedeployusr.ccf' \
                      'id_rsa.ibm.runtimedeployusr.sk' \
                      'id_rsa.ibm.runtimedeployusr.bmt'

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


export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}
[[ "${HOME}/.homebrewrc" ]] && source "${HOME}/.homebrewrc"

export DOTFILES="${HOME}/.mydotfiles"

[[ -d "${HOME}/.bin"       ]] && export PATH=${HOME}/.bin:${PATH}
[[ -d "${HOME}/.local/bin" ]] && export PATH=${HOME}/.local/bin:${PATH}

export PATH=/usr/local/sbin:${PATH}

# Custom configurations
TOGGLES_VERBOSE=true
declare -A TOGGLES_CONFIGURATION=(
  [direnv]=true
  [fzf]=true
  [github]=true
  [ghe]=true
  [ibmcloud]=true
  [volta]=true
  [pyenv]=true
  [go]=true
  [rust]=true
  [krew]=true
  [tfenv]=true
  [travis]=true
)

[[ -f "${HOME}/.togglesrc" ]] && source "${HOME}/.togglesrc"

# zsh plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=lightgrey,bg=black"

# themes
ZSH_THEME="powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

[[ -L "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"

# Custonm functions
for ff in ${HOME}/.zsh.d/*.zsh; do
  source "${ff}"
done 2>/dev/null

# Utilities and aliases
[[ -f "${HOME}/.aliasesrc" ]] && source "${HOME}/.aliasesrc"
