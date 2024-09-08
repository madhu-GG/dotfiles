# My Dotfiles

This is a collection of dotfiles that I use regularly.

## Table of Contents

1. [vim](#vim)
2. [neovim](#neovim)
3. [Tmux](#tmux)

## Vim

This is my vimrc file for vim. Should add more configuration as i explore vim.

+ Added Vundle Plugin Manager

### Prerequisites

* git and internet access if you want to install Vundle the vim plugin manager.
* recent version of vim, neovim, or gvim.
* optional: cmake, g++ and python3-dev to compile some Vundle plugins like YouCompleteMe

### Instructions to install

* run `./setup.sh vim`
* YouCompleteMe:
```
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py --clang-completer
```
## Neovim

* run `./setup.sh neovim`
* open neovim (nvim)
* type in ":LazyInstall" to install the plugins

## Tmux

* run `./setup.sh tmux`
* start tmux session with `tmux new-session [-s <name>]`
