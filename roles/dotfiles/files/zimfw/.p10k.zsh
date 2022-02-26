if [[ "${ZSH_THEME}" == "powerlevel10k" ]]; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rust nodenv pyenv virtualenv kubecontext vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
  POWERLEVEL9K_MODE="nerdfont-complete"
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_DELIMITER="·"
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_left"

  if [[ -r "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%)}:-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%)}:-%n}.zsh"
  fi
fi
