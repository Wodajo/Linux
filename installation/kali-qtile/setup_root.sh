#!/usr/bin/env bash

# Skript for Qtile on kali machine - try without any DE
# This part is to be run as root

read -p "Enter username: " USERNAME

echo "Installing dependencies system-wide"
apt install -y xserver-xorg zsh python3 python3-pip python3-xcffib python3-cffi libpangocairo-1.0-0 lxappearance lxpolkit nitrogen thunar picom alacritty lightdm lightdm-gtk-greeter blueman gnome-keyring okular alsa-utils flameshot brightnessctl galculator vim betterlockscreen
# xserver-xorg - X11 backend
# xcffib - required for X11 backend (has to be installed before cairocffi)
# cffi - bars & popups
# libpangocairo - writings on bars & popups
# asla-utils - for amixer controls

# Create qtile.desktop
cat <<- _EOF_ > qtile.desktop
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=/home/$USERNAME/.local/bin/qtile start
Type=Application
Keywords=wm;tiling
_EOF_

# Move qtile.desktop to /usr/share/xsessions/
mv qtile.desktop /usr/share/xsessions/

# Wallpapers
mkdir -p /usr/share/wallpapers
cp -r wallpapers/* /usr/share/wallpapers/
su --command='betterlockscreen -u /usr/share/wallpapers/wp11125106-endeavouros-wallpapers.jpg dim' $USERNAME

# Bluetooth applet
systemctl enable bluetooth.service
