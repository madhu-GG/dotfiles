#!/bin/bash

# setup vim
function vim() {
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	if [ -f ~/.vimrc ]; then
		mv ~/.vimrc ~/.vimrc_bkp
	fi

	cp vimrc ~/.vimrc
	vim +PluginInstall +qall
}

# setup tmux
function tmux() {
	if [ -f ~/.tmux.conf ]; then
		cp ~/.tmux.conf ~/.tmux.conf.backup
	fi

	cp tmux.conf ~/.tmux.conf
}

# setup neovim
function neovim() {
	if [ ! -d ~/.config/nvim ]; then
		echo "NVIM Config directory missing";
		mkdir -p ~/.config/nvim/lua/plugins;
		cp -R nvim ~/.config;
	fi
}

# display command usage:
function usage() {
	echo "usage: $0 <program> [program-options]";
}

case $1 in
	'vim')
		vim;
		;;
	'tmux')
		tmux;
		;;
	'neovim')
		neovim;
		;;
	*)
		usage;
		;;
esac
