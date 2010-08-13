#!/bin/bash


do_slink() {

  [ -f "${1}" -o -d "${1}" ] && ln -snf ${1} ${2}
}


MYDOTFILES=${MYDOTFILES:-`pwd`}
cd

##
# Shell
do_slink ${MYDOTFILES}/.inputrc
do_slink ${MYDOTFILES}/.bashrc
do_slink ${MYDOTFILES}/.bash_profile
do_slink ${MYDOTFILES}/.bash_logout

##
# Vim
do_slink ${MYDOTFILES}/.vim
do_slink ${MYDOTFILES}/.vim/.vimrc
do_slink ${MYDOTFILES}/.vim/.gvimrc

##
# Ruby stuff
do_slink ${MYDOTFILES}/ruby/.irbrc
do_slink ${MYDOTFILES}/ruby/.gemrc

##
# Screen
do_slink ${MYDOTFILES}/.screenrc

##
# SSH
do_slink ${MYDOTFILES}/ssh/config ${HOME}/.ssh/config

##
# Git
do_slink ${MYDOTFILES}/.gitconfig

