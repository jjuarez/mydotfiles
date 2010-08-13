#!/bin/bash

do_link() {

  ln -snf ${2} ${1}
}

[ -d ~/etc/mydotfiles ] && DOTFILES="~/etc/mydotfiles" || DOTFILES=`pwd`

cd

##
# Shell
do_link .inputrc      ${DOTFILES}/.inputrc
do_link .bashrc       ${DOTFILES}/.bashrc
do_link .bash_profile ${DOTFILES}/.bash_profile
do_link .bash_logout  ${DOTFILES}/.bash_logout
##
# Vim
do_link .vim          ${DOTFILES}/.vim
do_link .vimrc        ${DOTFILES}/.vimrc
##
# Ruby stuff
do_link .irbrc        ${DOTFILES}/irbrc
do_link .rdebugrc     ${DOTFILES}/.rdebugrc
##
# Screen
do_link .screenrc     ${DOTFILES}/.screenrc
##
## SSH
do_link .ssh/config   ${DOTFILES}/ssh/config
##
# Git
do_link .gitconfig    ${DOTFILES}/.gitconfig
