#!/bin/bash

# Requires minimal installation and working network.
# To retrieve this file, it's best to clone:
#      git@github.com:PierrotAWB/deploy.git
# (so it is assumed that git is already installed on the machine).

# If no username given, script will prompt when performing chsh.

username=$1


##### Dependencies
sudo pacman -Syu zsh


##### Shell
if [ -z "$username" ]; then
	echo "No user name given. Please enter one:"
	read username
fi
sudo chsh -s $(which zsh) $username


##### Configuration files
cd /tmp
git clone git@github.com:PierrotAWB/dotfiles.git 
cd dotfiles
mv -f * ~
cd


##### Scripts
cd ~/.local
git clone git@github.com:PierrotAWB/scripts.git
mv -f scripts bin


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
git clone git@github.com:PierrotAWB/st.git
git clone git@github.com:PierrotAWB/dwm.git
git clone git@github.com:PierrotAWB/dwmblocks.git
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
</fontconfig>" > /etc/local.conf
