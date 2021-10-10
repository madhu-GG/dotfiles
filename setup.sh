#!/bin/bash
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if [ -f ~/.vimrc ]; then
mv ~/.vimrc ~/.vimrc_bkp
fi
cp vimrc ~/.vimrc
vim +PluginInstall +qall
