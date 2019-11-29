#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# vim
ln -s ${BASEDIR}/.vimrc ~/.vimrc
ln -s ${BASEDIR}/.vim/ ~/.vim

# bash
ln -s ${BASEDIR}/.bashrc ~/.bashrc

# zsh
ln -s ${BASEDIR}/.zshrc ~/.zshrc
ln -s ${BASEDIR}/.zsh.d ~/.zsh.d

# git
ln -s ${BASEDIR}/.gitconfig ~/.gitconfig
