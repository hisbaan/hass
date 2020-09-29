#!/usr/bin/env bash
set -euo pipefail

###########################
### Installing Dotfiles ###
###########################

echo -e "Which dotfiles repo?\n    [1] Desktop\n    [2] Laptop"
read input

case "$input" in
    1) dotfiles_repo="https://github.com/hisbaan/dotfiles" ;;
    2) dotfiles_repo="https://github.com/hisbaan/dotfiles-laptop" ;;
esac

git clone "$dotfiles_repo" $HOME/hass/dotfiles

[ ! -d $HOME/.config ] && mkdir $HOME/.config
mv $HOME/hass/dotfiles/.config/* $HOME/.config/

[ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin
mv $HOME/hass/dotfiles/.local/bin/* $HOME/.local/bin/

[ ! -d $HOME/.xcolors ] && mkdir -p $HOME/.xcolors
mv $HOME/hass/dotfiles/.xcolors/* $HOME/.xcolors/

[ ! -d $HOME/.icons ] && mkdir -p $HOME/.icons
mv $HOME/hass/dotfiles/.icons/* $HOME/.icons/

[ ! -d $HOME/.themes ] && mkdir -p $HOME/.themes
mv $HOME/hass/dotfiles/.themes/* $HOME/.themes/

[ ! -d $HOME/.doom.d ] && mkdir -p $HOME/.doom.d
mv $HOME/hass/dotfiles/.doom.d/* $HOME/.doom.d/

mv $HOME/hass/dotfiles/.xinitrc $HOME/

###########################
### Installing packages ###
###########################

sudo pacman -Syu --needed < $HOME/hass/dotfiles/pkglist.txt

# yay -S --needed < $HOME/hass/dotfiles/pkglist-aur.txt
