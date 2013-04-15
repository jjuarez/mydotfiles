export MYDOTFILES=~/.mydotfiles
export ZSH=~/.oh-my-zsh
export ZSH_THEME="thejtoken"
export CASE_SENSITIVE="true"
export DISABLE_AUTO_UPDATE="false"

#plugins=(brew gitfast git-flow bundler bundler)
plugins=(osx tmux brew textmate sublime git-flow rvm bundler capistrano vagrant gem knife)


[ -f "${ZSH}/oh-my-zsh.sh" ] && . "${ZSH}/oh-my-zsh.sh"

##
# Set this better like a plugin
unsetopt correct_all

[ -f "${MYDOTFILES}/shell/shell.sh" ] && . "${MYDOTFILES}/shell/shell.sh"

[ -f ~/.rvm/scripts/rvm ] && { 

  . ~/.rvm/scripts/rvm
  PATH=${PATH}:${HOME}/.rvm/bin 
}
