#set -u -o pipefail
#set -x # Exteme debug mode

# Start configuration added by Zim install {{{
# zimfw configuration
export HISTFILE="${HOME}/.zsh_history"  # Try to share the shell history across subshells
setopt HIST_IGNORE_ALL_DUPS
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

# My dotfiles

# Theme
ZSH_THEME="powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(kubecontext pyenv dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER="·"
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_left"

zstyle ':zim:ssh' ids 'id_ed25519.github.ibm.com' \
                      'id_ed25519.ansible_provisioning_development' \
                      'id_ed25519.ansible_provisioning_staging' \
                      'id_ed25519.ansible_provisioning_production' \
                      'id_ed25519.github.com'

# Z configuration
export ZSHZ_CMD="z -e"
export ZSHZ_COMPLETION="frecent"
export ZSHZ_MAX_SCORE=9000

export HOMEBREW_NO_AUTO_UPDATE=1

[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

export DOTFILES="${HOME}/.mydotfiles"
export PATH=${PATH}:/usr/local/sbin:${DOTFILES}/bin

# Toggles
[[ -L "${HOME}/.togglesrc" ]] && {
  declare -A TOGGLES_CONFIGURATION=(
    [nodenv]=true
    [nvm]=true
    [ruby]=true
    [go]=true
    [tfenv]=true
    [github]=true
    [travis]=true
    [python]=true
    [direnv]=true
  )
  source "${HOME}/.togglesrc"
}

# Plugins
# fpath+=~/.zfunctions
# autoload docker::containers::clean
# autoload docker::images::clean
# autoload ibm::cloud::login
# autoload git::superlog
# autoload git::squash_branch
# autoload ssh::load_keys
# autoload k8s::iks_get_kubeconfigs
# autoload k8s::load_kubeconfigs
[[ -L "${HOME}/.zfunctions" ]] && {
  for pf in ${HOME}/.zfunctions/*.zsh; do
    source "${pf}"
  done 2>/dev/null
}

# Aliases
[[ -L "${HOME}/.aliasesrc" ]] && source "${HOME}/.aliasesrc"
