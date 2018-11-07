#!/usr/bin/env sh

ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Vim
ln -s $ROOT/.vimrc ~/.vimrc
ln -s $ROOT/.vim ~/.vim

# Zsh
ln -s $ROOT/.zshrc ~/.zshrc

# Git
ln -s $ROOT/.gitignore ~/.gitignore
ln -s $ROOT/.gitconfig ~/.gitconfig
