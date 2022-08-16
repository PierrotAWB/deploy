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
    `# audio     ` ncmpcpp mpd pulseaudio pulseaudio-alsa pavucontrol alsa-plugins alsa-utils \
    `# bluetooth ` bluez bluez-utils pulseaudio-bluetooth \
    `# code      ` neovim python python-pip go rust \
    `# desktop   ` slock \
    `# fonts     ` adobe-source-code-pro-fonts noto-fonts ttf-fira-code ttf-joypixels \
    `# misc      ` cronie zathura zathura-ps zathura-djvu \
    `# net       ` net-tools wget tcpdump tcpreplay traceroute \
    `# terminal  ` newsboat zsh \
    `# workflow  ` dmenu \
    `# x         ` xorg-server xorg-xinit xorg-xset xorg-xrandr xf86-input-libinput xf86-video-intel

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
for program in "brave" "lf"
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

# Misc. clean up
systemctl start cronie.service
systemctl enable cronie.service

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
		<prefer>
			<family>Inter</family>
		</prefer>
	</alias>
</fontconfig>" | sudo tee /etc/fonts/local.conf
