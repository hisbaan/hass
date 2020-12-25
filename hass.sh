###########################
### Installing Dotfiles ###
###########################

echo -e "Which dotfiles repo?\n    [1] Desktop\n    [2] Laptop"
read input

case "$input" in
    1) dotfiles_repo="https://github.com/hisbaan/dotfiles" ;;
    2) dotfiles_repo="https://github.com/hisbaan/dotfiles-laptop" ;;
esac

echo ""
echo "${bold}Getting dotfiles"
sudo sh -c "echo 'ZDOTDIR=$HOME/.config/zsh' >> /etc/zsh/zshenv"
export ZDOTDIR=$HOME/.config/zsh

git clone "$dotfiles_repo" $HOME/hass/dotfiles

[ ! -d $HOME/.config ] && mkdir $HOME/.config
cp -r $HOME/hass/dotfiles/.config/* $HOME/.config/

[ ! -d $HOME/.local/bin ] && mkdir -p $HOME/.local/bin
cp -r $HOME/hass/dotfiles/.local/bin/* $HOME/.local/bin/

[ ! -d $HOME/.xcolors ] && mkdir -p $HOME/.xcolors
cp -r $HOME/hass/dotfiles/.xcolors/* $HOME/.xcolors/

[ ! -d $HOME/.icons ] && mkdir -p $HOME/.icons
cp -r $HOME/hass/dotfiles/.icons/* $HOME/.icons/

[ ! -d $HOME/.themes ] && mkdir -p $HOME/.themes
cp -r $HOME/hass/dotfiles/.themes/* $HOME/.themes/

[ ! -d $HOME/.doom.d ] && mkdir -p $HOME/.doom.d
cp -r $HOME/hass/dotfiles/.doom.d/* $HOME/.doom.d/

cp $HOME/hass/dotfiles/.xinitrc $HOME/

###########################
### Installing packages ###
###########################

# enable multilib repos in pacman
sudo sh -c "sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf"

# Installing and using reflector
echo ""
echo "${bold}Installing reflector"
sudo pacman -S reflector
echo ""
echo "${bold}Rating mirrors. This may take some time"
sudo reflector --verbose -l 200 -n 20 -p https --sort rate --save /etc/pacman.d/mirrorlist

# Installing packages from the default repos
echo ""
echo "${bold}Installing packages"
sudo pacman -Syu --needed $(cat $HOME/hass/dotfiles/pkglist.txt)

# Installing AUR helper
echo ""
echo "${bold}Installing paru (AUR helper)"
git clone https://aur.archlinux.org/paru.git $HOME/paru
cd $HOME/paru
makepkg -si
cd $HOME
rm -rf paru

# Installing AUR packages
echo ""
echo "${bold}Installing AUR packages"
paru -S --needed < $HOME/hass/dotfiles/pkglist-aur.txt

# Installing ZSH plugins
echo ""
echo "${bold}Installing ZSH plugins"
mkdir $HOME/.config/zsh/plugins
git clone https://github.com/sharat87/zsh-vim-mode $HOME/.config/zsh/plugins/zsh-vim-mode
git clone https://github.com/zdharma/fast-syntax-highlighting $HOME/.config/zsh/plugins/fast-syntax-hightlighting

# Installing doom emacs
echo ""
echo "${bold}Installing doom emacs"
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
$HOME/.emacs.d/bin/doom install
