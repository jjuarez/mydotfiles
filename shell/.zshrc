export MYDOTFILES=~/.mydotfiles
export ZSH=~/.oh-my-zsh
export ZSH_THEME="thejtoken"
export CASE_SENSITIVE="true"
export DISABLE_AUTO_UPDATE="false"

plugins=(tmux brew git-flow rvm bundler vagrant gem knife)


[ -f "${ZSH}/oh-my-zsh.sh" ] && . "${ZSH}/oh-my-zsh.sh"

##
# Set this better like a plugin
unsetopt correct_all

[ -f "${MYDOTFILES}/shell/shell.sh" ] && . "${MYDOTFILES}/shell/shell.sh"

[ -s "${HOME}/.rvm/scripts/rvm"     ] && . "${HOME}/.rvm/scripts/rvm" 

export PATH=${HOME}/.rvm/bin:${PATH}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
