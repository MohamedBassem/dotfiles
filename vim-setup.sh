#!/bin/bash

sudo apt-get install -y vim git
pushd ~/
wget https://raw.githubusercontent.com/MohamedBassem/dotfiles/master/.vimrc
popd
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

