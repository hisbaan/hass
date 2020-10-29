###########################
### Installing Dotfiles ###
###########################

echo -e "Which dotfiles repo?\n    [1] Desktop\n    [2] Laptop"
read input

case "$input" in
    1) dotfiles_repo="https://github.com/hisbaan/dotfiles" ;;
    2) dotfiles_repo="https://github.com/hisbaan/dotfiles-laptop" ;;
esac

sudo sh -c "echo 'ZDOTDIR=$HOME/.config/zsh' >> /etc/zsh/zshenv"

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

sudo pacman -S reflector

sudo reflector --verbose -l 200 -n 20 -p https --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syu --needed $(cat $HOME/hass/dotfiles/pkglist.txt)

git clone https://aur.archlinux.org/paru.git $HOME/paru
cd $HOME/yay
makepkg -si
cd $HOME
rm -rf yay

paru -S --needed < $HOME/hass/dotfiles/pkglist-aur.txt

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zdharma/fast-syntax-highlighting.git $HOME/.config/zsh/oh-my-zsh/custom/plugins/fast-syntax-highlighting

git clone https://github.com/zigius/expand-ealias.plugin.zsh $HOME/.config/zsh/oh-my-zsh/custom/plugins/expand-ealias
echo "ealias sp='sudo pacman'" >> $HOME/.config/zsh/oh-my-zsh/custom/zsh-ealias.zsh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.config/zsh/oh-my-zsh/custom/themes/powerlevel10k
