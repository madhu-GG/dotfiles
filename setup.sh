#!/bin/bash
sudo apt install git vim
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/madhu-GG/vimrc.git madhu-vimrc
mv ~/.vimrc ~/.vimrc_bkp
cp madhu-vimrc/vimrc ~/.vimrc
vim +PluginInstall +qall
