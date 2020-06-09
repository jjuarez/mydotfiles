# Start configuration added by Zim install {{{

##
## zimfw configuration
##
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

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
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
# typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|kubie'

# Custom, kops & helm (you need this before to load the k8s plugin)
[[ -d "${HOME}/.helmenv" ]] && export PATH="${HOME}/.helmenv/bin:${PATH}"
[[ -d "${HOME}/.kopsenv" ]] && export PATH="${HOME}/.kopsenv/bin:${PATH}"
[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"

# SSH agent pre-loaded keys
zstyle ':zim:ssh' ids 'id_rsa.pi' 'id_rsa.mundokids' 'id_rsa.clarity.gitlab' 'ansible_provisioner_dev' 'ansible_provisioner_pre' 'ansible_provisioner_stg' 'ansible_provisioner_prod' 'ansible_provisioner_mgmt'

##
## dotfiles
##
[[ -n "${DOTFILES}" ]] || export DOTFILES="${HOME}/.mydotfiles"

export PATH=${PATH}:/usr/local/sbin:${DOTFILES}/bin

##
## Toggles
##
declare -A FTS=(
  [direnv]=false
  [krew]=true
  [tf]=true
  [python]=false
  [ruby]=false
  [java]=false
  [go]=true
  [github]=true
)

##
## MongoDB support
##
MONGODB_PATH="/Applications/MongoDB.app/Contents/Resources/Vendor/mongodb/bin"

[[ -d "${MONGODB_PATH}" ]] && export PATH=${PATH}:${MONGODB_PATH}

##
## Custom plugins
##
for f in ${HOME}/.functions/*.zsh; do
  source "${f}"
done 2>/dev/null

##
## Aliases
## 
[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"
