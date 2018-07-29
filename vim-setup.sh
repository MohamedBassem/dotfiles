#!/bin/bash

brew install vim git cmake python-dev
pushd ~/
wget https://raw.githubusercontent.com/MohamedBassem/dotfiles/master/.vimrc
popd
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# For YCM
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer

