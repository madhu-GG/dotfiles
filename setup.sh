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
	set -x;
	if [ ! -d "$XDG_CONFIG_HOME" ]; then
		DEST_DIR="$HOME/.config/tmux";
		mkdir -p "$DEST_DIR";
	fi

	DEST="$DEST_DIR/tmux.conf";
	if [ -f "$DEST" ]; then
		cp "$DEST" "$DEST.backup";
	fi

	cp tmux.conf "$DEST";

	# setup some aliases for tmux commands
	echo "alias tmux='tmux -u'" > ~/.bashrc_tmux
	echo "alias tn='tmux new-session'" >> ~/.bashrc_tmux
	echo "alias ta='tmux attach-session'" >> ~/.bashrc_tmux

	echo "
if [ -f ~/.bashrc_tmux ]; then
	source ~/.bashrc_tmux;
fi" >> ~/.bashrc

	set +x;
}

# setup neovim
function neovim() {
	if [ -d ~/.config/nvim ]; then
		echo "NVIM Config directory exists, moving it 'nvim_old' ...";
		mv ~/.config/nvim ~/.config/nvim_old
	fi

	cp -R nvim ~/.config;
}

# display command usage:
function usage() {
	echo "usage: $0 <program> [program-options]";

	echo "";
	echo "<program> Currently supports";
	echo "    vim";
	echo "    tmux";
	echo "    neovim";
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
