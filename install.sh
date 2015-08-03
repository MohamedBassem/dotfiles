#!/bin/bash

cd

# Installing some packages
sudo apt-get install -y git htop tmux curl

#Cloning dotfiles
git clone https://github.com/MohamedBassem/dotfiles
cd dotfiles
ls -sf "`pwd`/.bashrc" ~/.bashrc
ls -sf "`pwd`/.gitignore" ~/.gitignore
ls -sf "`pwd`/.gitconfig" ~/.gitconfig
ls -sf "`pwd`/.tmux.conf" ~/.tmux.conf

# For tmuxinator
sudo apt-get install -y rbenv
sudo gem install tmuxinator

# Install Tomorrow Night Theme
#./tomorrow-night.sh

# Install vim
./vim-setup.sh

source ~/.bashrc

