#!/bin/bash
sudo apt install git vim
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mv ~/.vimrc ~/.vimrc_bkp
cp vimrc ~/.vimrc
vim +PluginInstall +qall
