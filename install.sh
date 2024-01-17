#!/bin/bash

# Installing some packages
brew install git htop tmux curl

#Cloning dotfiles
ls -sf "`pwd`/fish" ~/.config/fish
ls -sf "`pwd`/nvim" ~/.config/nvim
ls -sf "`pwd`/.gitignore" ~/.gitignore
ls -sf "`pwd`/.gitconfig" ~/.gitconfig
ls -sf "`pwd`/.tmux.conf" ~/.tmux.conf
