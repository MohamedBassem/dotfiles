#!/bin/bash

# Installing some packages
brew install git htop tmux curl

#Cloning dotfiles
ls -sf "`pwd`/.bashrc" ~/.bashrc
ls -sf "`pwd`/.gitignore" ~/.gitignore
ls -sf "`pwd`/.gitconfig" ~/.gitconfig
ls -sf "`pwd`/.tmux.conf" ~/.tmux.conf

# Install vim
./vim-setup.sh
