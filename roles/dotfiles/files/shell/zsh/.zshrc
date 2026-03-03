# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH Profiling BEGIN
# zmodload zsh/zprof

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

export MYDOTFILES="${HOME}/.mydotfiles"

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
  [ghe]=true
  [github]=true
  [go]=false
  [java]=true
  [ibmcloud]=true
  [krew]=true
  [rust]=false
  [tfenv]=true
  [volta]=false
  [zoxide]=true
)

[[ -f "${HOME}/.featuresrc" ]] && source "${HOME}/.featuresrc"

# zsh plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=lightgrey,bg=black"

# Utilities and aliases
for ff in ${HOME}/.zsh.d/*.zsh; do
  source "${ff}"
done

[[ -f "${HOME}/.aliasesrc" ]] && source "${HOME}/.aliasesrc"

# ZSH Profiling END
# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
