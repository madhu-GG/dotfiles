#!/bin/env bash

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
	if (( $DEBUG == 1 )); then
		set -x;
	fi

	VERSION=$1
	if [ ! -d "$XDG_CONFIG_HOME" ]; then
		DEST_DIR="$HOME/.config/tmux";
		mkdir -p "$DEST_DIR";
	fi

	DEST="$DEST_DIR/tmux.conf";
	if [ -f "$DEST" ]; then
		cp "$DEST" "$DEST.backup";
	fi

	case $VERSION in
	1)
		tmux_config='tmux.conf'
		;;
	2)
		tmux_config='tmux.conf.2'
		;;
	*)  tmux_config='tmux.conf'
		;;
	esac
	
	echo "Selected ${tmux_config}";
	cp "${tmux_config}" "$DEST";

	# setup some aliases for tmux commands
	if ! [ -f ~/.bashrc_tmux ]; then
		cp bashrc_tmux ~/.bashrc_tmux
		echo "DONE copy: bashrc_tmux to ~/.bashrc_tmux"
		if ! grep -q "bashrc_tmux" ~/.bashrc; then
			echo "
if [ -f ~/.bashrc_tmux ]; then
	source ~/.bashrc_tmux;
fi" >> ~/.bashrc
			echo "DONE modify: source ~/.bashrc_tmux from ~/.bashrc"
		else
			echo "SKIP modify: ~/.bashrc already sources ~/.bashrc_tmux"
		fi
		source ~/.bashrc
	else
		echo "SKIP copy: bashrc_tmux already exists"
	fi

	if (( $DEBUG == 1 )); then
		set +x;
	fi
}

# setup neovim
function neovim() {
	if [ -d ~/.config/nvim ]; then
		echo "NVIM Config directory exists, moving it 'nvim_old' ...";
		mv ~/.config/nvim ~/.config/nvim_old
	else
		echo "Copying nvim config to .config/";
		cp -R nvim ~/.config;
	fi
}

# display command usage:
function usage() {
	echo "usage: $0 <program> [program-options] [debug]";

	echo "";
	echo "<program> Currently supports";
	echo "    vim";
	echo "    tmux";
	echo "    neovim";

	echo "program-options";
	echo "    tmux";
	echo "      version: 1 or 2 -> copies either tmux.conf or tmux.conf.2,";
	echo "      default is 1";
}

case $3 in
	'debug')
		DEBUG=1;
		;;
	*)
		DEBUG=0;
		;;
esac

case $1 in
	'vim')
		vim;
		;;
	'tmux')
		tmux $2;
		;;
	'neovim')
		neovim;
		;;
	*)
		usage;
		;;
esac
