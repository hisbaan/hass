#!/bin/env bash

if [[ ! $(pacman -Qi git) ]] || [[ ! $(pacman -Qi sudo) ]]
then
    echo "${bold}Please install the above mentioned packages via \`sudo pacman -S <package-name>\` then re-run the script"
    exit 1
fi

echo -e "${bold}Please ensure your mirrorlist is rated to speed up setup time. You can do this with the following commands\nsudo pacman -S reflector\nsudo reflector --verbose -l 200 -n 20 -p https --sort rate -c Canada --save /etc/pacman.d/mirrorlist"

###########################
### Installing Dotfiles ###
###########################

cd "$HOME" || exit

echo ""
echo -e "Which dotfiles repo?\n    [1] Desktop\n    [2] Laptop"
read -r input

case "$input" in
    1) dotfiles_branch="desktop" ;;
    2) dotfiles_branch="laptop" ;;
esac

echo ""
echo "${bold}Getting dotfiles"

# Clone dotfiles repository then switch to the correct branch
git clone https://github.com/hisbaan/dotfiles "$HOME/hass/dotfiles" || exit
cd "$HOME/hass/dotfiles" || exit
git checkout $dotfiles_branch
cd "$HOME" || exit

sudo mkdir -p /etc/zsh
sudo sh -c "echo 'ZDOTDIR=$HOME/.config/zsh' >> /etc/zsh/zshenv"
export ZDOTDIR="$HOME/.config/zsh"

# Backing up old configs.
echo ""
echo "${bold}Backing up current config to ~/hass-backup"
mkdir -p "$HOME/hass-backup"
mkdir -p "$HOME/hass-backup/.local/share"
mkdir -p "$HOME/hass-backup/.local/bin/scripts"
[ -d "$HOME/.config" ]                && mv "$HOME/.config"               "$HOME/hass-backup/.config"
[ -d "$HOME/.local/bin/scripts" ]     && mv "$HOME/.local/bin/scripts"    "$HOME/hass-backup/.local/bin/scripts"
[ -d "$HOME/.icons" ]                 && mv "$HOME/.icons"                "$HOME/hass-backup/.icons"
[ -d "$HOME/.themes" ]                && mv "$HOME/.themes"               "$HOME/hass-backup/.themes"
[ -d "$HOME/.doom.d" ]                && mv "$HOME/.doom.d"               "$HOME/hass-backup/.doom.d"
[ -d "$HOME/.unison" ]                && mv "$HOME/.unison"               "$HOME/hass-backup/.unison"
[ -f "$HOME/.xinitrc" ]               && mv "$HOME/.xinitrc"              "$HOME/hass-backup/.xinitrc"
[ -d "$HOME/.local/share/flavours" ]  && mv "$HOME/.local/share/flavours" "$HOME/hass-backup/.local/share/flavours"

# Install new configs.
echo ""
echo "${bold}Moving new config to correct location"
DOT=$HOME/hass/dotfiles

mkdir "$HOME/.config"
cp -r "$DOT/.config/*" "$HOME/.config/"

mkdir -p "$HOME/.local/bin/scripts"
cp -r "$DOT/.local/bin/scripts/*" "$HOME/.local/bin/scripts"

mkdir -p "$HOME/.icons"
cp -r "$DOT/.icons/*" "$HOME/.icons/"

mkdir -p "$HOME/.themes"
cp -r "$DOT/.themes/*" "$HOME/.themes/"

mkdir -p "$HOME/.doom.d"
cp -r "$DOT/.doom.d/*" "$HOME/.doom.d/"

mkdir -p "$HOME/.unison"
cp -r "$DOT/.unison/*" "$HOME/.unison/"

cp "$DOT/.xinitrc" "$HOME/"

mkdir -p "$HOME/.local/share/flavours"
cp -r "$DOT/.local/share/flavours" "$HOME/.local/share/flavours"

###########################
### Installing packages ###
###########################

# Installing packages from the default repos.
echo ""
echo "${bold}Installing packages"
sudo pacman -Syu --needed "$(cat "$DOT/pkglist.txt")"

# Installing AUR helper.
echo ""
echo "${bold}Installing paru (AUR helper)"
git clone https://aur.archlinux.org/paru-bin.git "$HOME/paru"
cd "$HOME/paru" || exit
makepkg -si
cd "$HOME" || exit
rm -rf paru

# Extra GPG keys
curl https://github.com/olets.gpg | gpg --import

# Installing AUR packages.
echo ""
echo "${bold}Installing AUR packages"
paru -S --needed < "$DOT/pkglist-aur.txt"

# Installing ZSH plugins.
echo ""
echo "${bold}Installing ZSH plugins"
mkdir "$HOME/.config/zsh/plugins"
git clone https://github.com/softmoth/zsh-vim-mode "$HOME/.config/zsh/plugins/zsh-vim-mode"
git clone https://github.com/z-shell/F-Sy-H "$HOME/.config/zsh/plugins/F-Sy-H"

echo ""
echo "Done! Enjoy the dots!" | figlet

echo ""
echo "N.B.: Some things may not be working correctly immediately. Please restart your machine to ensure that everything is working as intended."
