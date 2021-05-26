#!/bin/bash

# Requires minimal installation and working network.
# To retrieve this file, it's best to clone:
#      git@github.com:PierrotAWB/deploy.git
# (so it is assumed that git is already installed on the machine).

set -x

##### Dependencies
sudo pacman -Syu zsh


##### Shell
chsh -s $(which zsh)


##### Configuration files
cd /tmp
[ -d dotfiles ] && rm -rf dotfiles
git clone https://github.com/PierrotAWB/dotfiles.git 
[ -d ~/.config ] && rm -rf ~/.config
mv dotfiles ~/.config
cd


##### Scripts
mkdir -p ~/.local
cd ~/.local
[ -d scripts ] && rm -rf scripts
[ -d bin ] && rm -rf bin
git clone https://github.com/PierrotAWB/scripts.git
mv scripts bin


##### Programs
sudo pacman -Syu ranger newsboat ncmpcpp mpd

cd /tmp
git clone https://aur.archlinux.org/brave.git
cd brave
makepkg -si

cd ~/.local/bin
./build-vim

# Suckless
cd ~/.config
git clone https://github.com/PierrotAWB/st.git
git clone https://github.com/PierrotAWB/dwm.git
git clone https://github.com/PierrotAWB/dwmblocks.git
cd st && sudo make install 
cd ../dwm && sudo make install
cd ../dwmblocks && sudo make install
cd


##### Misc.
 
# cron
sudo pacman -Syu cronie
systemctl start cronie.service
systemctl enable cronie.service

# Fonts
sudo pacman -Syu ttf-fira-code ttf-joypixels
sudo touch /etc/fonts/local.conf
sudo echo "<?xml version=\"1.0\"?>
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
</fontconfig>" > /etc/fonts/local.conf
