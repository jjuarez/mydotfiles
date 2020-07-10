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

# Term customizations
TERM=xterm-256color
export LANG=en_US.UTF-8

# Theme
ZSH_THEME="powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(aws kubecontext dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_left"

# SSH agent pre-loaded keys
zstyle ':zim:ssh' ids 'id_rsa.pi' 'id_rsa.mundokids' 'id_rsa.clarity.gitlab' 'ansible_provisioner_dev' 'ansible_provisioner_pre' 'ansible_provisioner_stg' 'ansible_provisioner_prod' 'ansible_provisioner_mgmt'

[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# dotfiles
[[ -n "${DOTFILES}" ]] || export DOTFILES="${HOME}/.mydotfiles"

export PATH=${PATH}:/usr/local/sbin:${DOTFILES}/bin

# Toggles
[[ -L "${HOME}/.togglesrc" ]] && {
  declare -A TOGGLES_CONFIGURATION=(
    [python]=false
    [tf]=true
    [ruby]=false
    [go]=true
    [node]=true
    [github]=true
    [travis]=true
  )

  source "${HOME}/.togglesrc"
}

# Plugins
for plugin_file in ${HOME}/.functions/*.zsh; do
  source "${plugin_file}"
done 2>/dev/null

#fpath=(~/.functions $fpath)

## Aliases
[[ -f "${HOME}/.aliasesrc" ]] && source "${HOME}/.aliasesrc"
