#!/bin/bash


do_slink() {

  [ -f "${1}" -o -d "${1}" ] && ln -snf ${1} ${2}
}


MYDOTFILES=${MYDOTFILES:-`pwd`}
cd

##
# Shell
for shell_cf in .bashrc .bash_profile .bash_logout .inputrc; do

  do_slink ${MYDOTFILES}/${shell_cf}
done

##
# Vim
for vim_cf in .vim .vim/.vimrc .vim/.gvimrc; do

  do_slink ${MYDOTFILES}/${vim_cf}
done

##
# Ruby stuff
for ruby_cf in .irbrc .gemrc .ree; do

  do_slink ${MYDOTFILES}/ruby/${ruby_cf}
done

##
# Screen
do_slink ${MYDOTFILES}/.screenrc

##
# SSH
do_slink ${MYDOTFILES}/ssh/config ${HOME}/.ssh/config

##
# Git
do_slink ${MYDOTFILES}/.gitconfig

