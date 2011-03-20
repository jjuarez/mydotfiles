#!/bin/bash


log_message() {

  [ -n "${1}" ] && echo -e "${1}" >&2
}

do_slink() {

  [ -f "${1}" -o -d "${1}" ] && {

    log_message "Linking ${1}"
    ln -nfs ${1} ${2} 
  } || {

    log_message "Not found: ${1}"
  }
}

MYDOTFILES=${MYDOTFILES:-`pwd`}
cd ${HOME}

##
# Shell
log_message "Shell..."
do_slink ${MYDOTFILES}/bash_profile ${HOME}/.bashrc
do_slink ${MYDOTFILES}/bash_profile ${HOME}/.bash_profile

##
# Vim
log_message "Vim links..."
do_slink ${MYDOTFILES}/vim        ${HOME}/.vim
do_slink ${MYDOTFILES}/vim/vimrc  ${HOME}/.vimrc
do_slink ${MYDOTFILES}/vim/gvimrc ${HOME}/.gvimrc

##
# Ruby 
log_message "Ruby..."
do_slink ${MYDOTFILES}/ruby/irbrc ${HOME}/.irbrc
do_slink ${MYDOTFILES}/ruby/gemrc ${HOME}/.gemrc
do_slink ${MYDOTFILES}/rvm/rvmrc  ${HOME}/.rvmrc

##
# SSH
log_message "SSH..."
do_slink ${MYDOTFILES}/ssh/config ${HOME}/.ssh/config

##
# Git
log_message "Git..."
do_slink ${MYDOTFILES}/git/gitconfig ${HOME}/.gitconfig
