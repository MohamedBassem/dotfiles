#!/bin/bash

# Installing some packages
brew install git htop tmux curl

#Cloning dotfiles
ln -sf "`pwd`/fish" ~/.config/fish
ln -sf "`pwd`/nvim" ~/.config/nvim
ln -sf "`pwd`/.gitignore" ~/.gitignore
ln -sf "`pwd`/.gitconfig" ~/.gitconfig
ln -sf "`pwd`/.tmux.conf" ~/.tmux.conf
