#!/usr/bin/env bash

# Skript for Qtile on native arch
# This part is to be run per-user

echo "[+] pip Installing qtile & cairocffi"
pip install --no-cache-dir cairocffi
pip install psutil
pip install qtile


# Copy & source zsh dotfiles
cp -r config/zsh/dotfiles/. $HOME/  # /. needed for dotfiles copying  # .zshenv & .xsession
source $HOME/.zshenv
cp -r config/zsh/. $ZDOTDIR  # .zshrc

# Make directories for config files  - probably redundant step (you could just copy dirs where they should be)
mkdir -p $XDG_CONFIG_HOME/qtile
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/rofi

# Copy config files
cp -r config/qtile/* $XDG_CONFIG_HOME/qtile/  # config.py & autostart.sh
cp -r config/alacritty/* $XDG_CONFIG_HOME/alacritty/  # alacritty.yml
cp -r config/rofi/* $XDG_CONFIG_HOME/rofi/  # rofi.rasi & Monokai.rasi
#cp config/picom.conf ~/.config  - you can mess with shadows and stuff later

# Appimages
APP="$HOME/Downloads/Appimages_waiting_for_installation"
if [ ! -d "$APP" ]; then
	mkdir -p $APP
fi
if [ ! -e "$APP/drawio-x86_64-20.7.4.AppImage"]; then
	wget https://github.com/jgraph/drawio-desktop/releases/download/v20.7.4/drawio-x86_64-20.7.4.AppImage
	mv ./drawio-x86_64-20.7.4.AppImage $APP
fi

# paru install (pvpn, obsidian)
echo "[+] paru installing pvpn and obsidian"
paru -S --skipreview --needed protonvpn-cli obsidian aur/betterlockscreen

# screen lock
betterlockscreen -u /usr/share/wallpapers/wp11125106-endeavouros-wallpapers.jpg dim

# chenge default to zsh
chsh -s $(which zsh)

# Closing words
echo "Done. Remember to set up ks and login to protonvpn-cli"
