#!/usr/bin/env bash

# Skript for Qtile on kali machine - try without any DE

read -p "Enter username: " USERNAME
QTILE_CONFIG_DIR="/home/$USERNAME/.config/qtile"
ALA_CONFIG_DIR="/home/$USERNAME/.config/alacritty"
ROFI_CONFIG_DIR="/home/$USERNAME/.config/rofi"

echo "Installing dependencies"
apt install -y xserver-xorg zsh python3 python3-pip python3-xcffib python3-cffi libpangocairo-1.0-0 lxappearance lxpolkit nitrogen thunar picom alacritty lightdm lightdm-gtk-greeter blueman gnome-keyring okular alsa-utils flameshot brightnessctl galculator vim-gtk3 betterlockscreen
# xserver-xorg - X11 backend
# xcffib - required for X11 backend (has to be installed before cairocffi)
# cffi - bars & popups
# libpangocairo - writings on bars & popups
# asla-utils - for amixer controls

echo "Installing qtile & cairocffi"
su --command='pip install --no-cache-dir cairocffi' $USERNAME
su --command='pip install psutil' $USERNAME
su --command='pip install qtile' $USERNAME



echo "Creating, moving and copying Qtile config files"

# Create qtile.desktop
cat <<- _EOF_ > qtile.desktop
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=/home/$USERNAME/.local/bin/qtile start
Type=Application
Keywords=wm;tiling
_EOF_

# Adding cmds to .xprofile (started with Window Manager) - rest is in autostart.sh
cat <<- _EOF_ >> /home/$USERNAME/.xprofile
setxkbmap pl
_EOF_

# Create .zshenv (for XDG env specification of each zsh session)
cat <<- _EOF_ > /home/$USERNAME/.zshenv
# Place for ENV of all zsh sessions

# XDG Base Directory specification defines where certain files are located
# only XDG_RUNTIME_DIR is set by default (via pam_systemd)

# where user-specific conf should be written (/etc analogue)
export XDG_CONFIG_HOME="$HOME/.config"
# where user-specific data files should be written (/usr/share analogue)?
export XDG_DATA_HOME="$XDG_CONFIG_HOME/.local/share"
# where user-specific non-essential (cached) data should be written (/var/cache analogue)
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# default text editor
export EDITOR="vim"
_EOF_

# Move qtile.desktop to /usr/share/xsessions/
mv qtile.desktop /usr/share/xsessions/

# Make directories for Qtile
mkdir -p $QTILE_CONFIG_DIR
mkdir -p $ALA_CONFIG_DIR
mkdir -p $ROFI_CONFIG_DIR
mkdir -p /usr/share/wallpapers

# Copy config files
cp -r config/qtile/* $QTILE_CONFIG_DIR/  # config.py & autostart.sh
cp -r config/alacritty/* $ALA_CONFIG_DIR/  # alacritty config
cp -r config/rofi/* $ROFI_CONFIG_DIR/  # rofi config
#cp config/picom.conf ~/.config  - you can mess with shadows and stuff later

# Wallpapers
cp -r wallpapers/* /usr/share/wallpapers/
su --command='betterlockscreen -u /usr/share/wallpapers/wp11125106-endeavouros-wallpapers.jpg dim' $USERNAME

    
# Permissions
chmod 744 $QTILE_CONFIG_DIR/autostart.sh
chmod 744 $QTILE_CONFIG_DIR/config.py

# Bluetooth applet
systemctl enable bluetooth.service

# Cleaning
