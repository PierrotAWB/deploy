#!/bin/bash

###
#
# Requires minimal installation and working network.
# To retrieve this file, it's best to clone:
#      git@github.com:PierrotAWB/deploy.git
# (so it is assumed that git, and internet utilities are
# already installed on the machine).
#
# The following are not installed / configured:
#   - Neomutt
#   - files
#   - LUKS
#
###

set -x

# Basic Packages
sudo pacman -Syu \
    `# archive   ` p7zip zip unzip unrar \
    `# audio     ` ncmpcpp mpd pulseaudio pulseaudio-alsa pavucontrol alsa-plugins alsa-utils mediainfo pamixer \
    `# bluetooth ` bluez bluez-utils pulseaudio-bluetooth \
    `# code      ` neovim python python-pip go rust nodejs npm \
    `# desktop   ` slock feh \
    `# fonts     ` adobe-source-code-pro-fonts noto-fonts ttf-fira-code ttf-joypixels inter-font ttf-font-awesome \
    `# misc      ` cronie xclip zathura zathura-ps zathura-djvu zathura-pdf-poppler xbindkeys bc light \
    `# net       ` openssh net-tools wget tcpdump tcpreplay traceroute \
    `# pictures  ` maim ueberzug sxiv \
    `# terminal  ` newsboat zsh fzf ripgrep bat \
    `# video     ` mpv yt-dlp \
    `# workflow  ` dmenu \
    `# x         ` xorg-server xorg-xinit xorg-xset xorg-xrandr xf86-input-libinput xf86-video-intel xcompmgr

chsh -s "$(which zsh)"

# Configuration
cd /tmp || exit
rm -rf dotfiles config
git clone https://github.com/PierrotAWB/dotfiles.git
for dir in ".config" ".xinitrc" ".zshenv"
do
	mv "dotfiles/$dir" "$HOME/$dir"
done

# Scripts
mkdir -p ~/.local && cd ~/.local || exit
rm -rf scripts bin
git clone https://github.com/PierrotAWB/scripts.git
mv scripts bin

# AUR
for program in "brave-bin" "lf" "libxft-bgra"
do
	cd /tmp || exit
	git clone "https://aur.archlinux.org/$program.git"
	cd "$program" || exit
	makepkg -si
done

# Suckless
for program in "st" "dwm" "dwmblocks"
do
	cd ~/.config || exit
	git clone "https://github.com/PierrotAWB/$program.git"
	cd "$program" || exit
	sudo make install
done

# Vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --headless +PlugInstall +qa

# Misc. clean up
for service in "cronie" "bluetooth"
do
	systemctl enable "service"
	systemctl start "service"
done

# Fonts
sudo touch /etc/fonts/local.conf
echo "<?xml version=\"1.0\"?>
<!DOCTYPE fontconfig SYSTEM \"urn:fontconfig:fonts.dtd\">
<fontconfig>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Fira Code</family>
		</prefer>
	</alias>
	<alias>
		<prefer>
			<family>Inter</family>
		</prefer>
	</alias>
</fontconfig>" | sudo tee /etc/fonts/local.conf
