if [[ "${ZSH_THEME}" == "powerlevel10k" ]]; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(wifi dir nodenv pyenv kubecontext vcs direnv)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
  POWERLEVEL9K_MODE="nerdfont-complete"
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_DELIMITER="·"
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_left"
  POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|k9s|stern|kubie'
fi
