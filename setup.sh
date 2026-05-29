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

	version=$1
	if [ ! -d "$xdg_config_home" ]; then
		dest_dir="$home/.config/tmux";
		mkdir -p "$dest_dir";
	fi

	dest="$dest_dir/tmux.conf";
	if [ -f "$dest" ]; then
		cp "$dest" "$dest.backup";
	fi

	case $version in
	1)
		tmux_config='tmux.conf'
		;;
	2)
		tmux_config='tmux.conf.2'
		;;
	*)  tmux_config='tmux.conf'
		;;
	esac
	
	echo "selected ${tmux_config}";
	cp "${tmux_config}" "$dest";

	# setup some aliases for tmux commands
	if ! [ -f ~/.bashrc_tmux ]; then
		cp bashrc_tmux ~/.bashrc_tmux
		echo "done copy: bashrc_tmux to ~/.bashrc_tmux"
		if ! grep -q "bashrc_tmux" ~/.bashrc; then
			echo "
if [ -f ~/.bashrc_tmux ]; then
	source ~/.bashrc_tmux;
fi" >> ~/.bashrc
			echo "done modify: source ~/.bashrc_tmux from ~/.bashrc"
		else
			echo "skip modify: ~/.bashrc already sources ~/.bashrc_tmux"
		fi
		source ~/.bashrc
	else
		echo "skip copy: bashrc_tmux already exists"
	fi

	if (( $DEBUG == 1 )); then
		set +x;
	fi
}

function alacritty() {
	echo "Setting up alacritty.toml configuration...";
	if (( $DEBUG == 1 )); then
		set -x;
	fi

	dest_dir="${HOME}/.config/alacritty";
	if [ ! -d "${XDG_CONFIG_HOME}" ]; then
		mkdir -p "${dest_dir}";
	fi

	dest="${dest_dir}/alacritty.toml";
	if [ -f "$dest" ]; then
		echo "Found existing alacritty.toml at ${dest_dir}...";
		cp "${dest}" "${dest}.backup";
	fi

	alacritty_config="alacritty/alacritty.toml";
	cp "${alacritty_config}" "$dest";

	if [ -f "${HOME}/alacritty.toml" ]; then
		echo "Skipping linking... symlink exists";
	else
		ln -s "${dest}" "${HOME}/alacritty.toml";
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
	echo "    alacritty";
    echo "";

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
	'alacritty')
		alacritty;
		;;
	*)
		usage;
		;;
esac
