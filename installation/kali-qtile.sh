#! /usr/bin/env bash

# Skript for Qtile on kali machine - try without any DE

read -p "Enter username: " USERNAME

echo "Installing dependencies"
apt install -y xserver-xorg python3 python3-pip python3-xcffib python3-cffi libpangocairo-1.0-0 lxappearance lxpolkit nitrogen thunar picom alacritty lightdm lightdm-gtk-greeter blueman gnome-keyring
# xserver-xorg - X11 backend
# xcffib - required for X11 backend (has to be installed before cairocffi)
# cffi - bars & popups
# libpangocairo - writings on bars & popups
# (graphic icons from https://fontawesome.com/icons)

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

# Move qtile.desktop to /usr/share/xsessions/
mv qtile.desktop /usr/share/xsessions/

# Make directories for Qtile
mkdir -p /home/$USERNAME/.config/qtile
#mkdir -p ~/.config/rofi  - do you want it or dmenu?
#mkdir -p ~/Pictures/wallpapers  - do you want to keep wallpapers in global share dir?

# Copy config files
cp -r config/qtile/* /home/$USERNAME/.config/qtile/  # config.py & autostart.sh
#cp -r config/rofi/* ~/.config/rofi/
#cp config/picom.conf ~/.config  - you can mee with shadows and stuff later

# Copy wallpapers
#cp -r wallpapers/* ~/pictures/wallpapers/


# Permissions
chmod 744 /home/$USERNAME/.config/qtile/autostart.sh
chmod 744 /home/$USERNAME/.config/qtile/config.py

# Cleaning


# 
