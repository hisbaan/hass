#!/usr/bin/env bash
set -euo pipefail

###########################
### Installing Dotfiles ###
###########################

echo -e "Which dotfiles repo?\n    [1] Desktop\n    [2] Laptop"
read input

case "$input" in
    1) dotfiles_repo="git@github.com:hisbaan/dotfiles" ;;
    2) dotfiles_repo="git@github.com:hisbaan/dotfiles-laptop" ;;
esac

git clone "$dotfiles_repo" $HOME/hass/dotfiles
