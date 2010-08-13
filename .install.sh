#!/bin/bash

do_link() {

  ln -snf ${2} ${1}
}

[ -d ~/etc/mydotfiles ] && DOTFILES="~/etc/mydotfiles" || DOTFILES=`pwd`

##
# Shell
do_link ~/.inputrc      ${DOTFILES}/.inputrc
do_link ~/.bashrc       ${DOTFILES}/.bashrc
do_link ~/.bash_profile ${DOTFILES}/.bash_profile
do_link ~/.bash_logout  ${DOTFILES}/.bash_logout

##
# Vim
do_link ~/.vim          ${DOTFILES}/.vim
do_link ~/.vimrc        ${DOTFILES}/.vim/.vimrc
do_link ~/.gvimrc       ${DOTFILES}/.vim/.gvimrc

##
# Ruby stuff
do_link ~/.irbrc        ${DOTFILES}/ruby/.irbrc
do_link ~/.gemrc        ${DOTFILES}/ruby/.gemrc

##
# Screen
do_link ~/.screenrc     ${DOTFILES}/.screenrc

##
## SSH
do_link ~/.ssh/config   ${DOTFILES}/ssh/config

##
# Git
do_link ~/.gitconfig    ${DOTFILES}/.gitconfig
