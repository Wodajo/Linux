#!/usr/bin/env bash

# Skript for Qtile on native arch
# This part is to be run as root

read -p "Enter username: " USERNAME

echo "[+] Installing dependencies system-wide"
pacman -Syu --noconfirm --disable-download-timeout --needed
pacman -S --noconfirm --disable-download-timeout --needed xorg-server zsh python3 python-pip python-xcffib python-cffi pango lxappearance-gtk3 polkit nitrogen thunar picom alacritty lightdm lightdm-gtk-greeter blueman gnome-keyring okular firefox alsa-utils flameshot brightnessctl galculator vim xclip cups foomatic-db foomatic-db-engine foomatic-db-gutenprint-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds foomatic-db-ppds ghostscript gsfonts gutenprint obs-studio nomacs vlc paru zsh-syntax-highlighting zsh-autosuggestions ttf-nerd-fonts-symbols-2048-em ttf-nerd-fonts-symbols-common ttf-liberation ttf-dejavu ttf-cascadia-code xorg-fonts-encodings ttf-bitstream-vera noto-fonts libxfont2 libfontenc gsfonts freetype2 fontconfig cantarell-fonts adobe-source-code-pro-fonts unzip unrar thunar-archive-plugin  thunar-media-tags-plugin thunar-volman
# xserver-xorg - X11 backend
# xcffib - required for X11 backend (has to be installed before cairocffi)
# cffi - bars & popups
# libpangocairo - writings on bars & popups  # I try to change it to pango
# asla-utils - for amixer controls
# I try lxappearance-gtk3 instead of lxappearance (bcos inter-dependecy confilcs) - customize look and feel

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
# su --command='betterlockscreen -u /usr/share/wallpapers/wp11125106-endeavouros-wallpapers.jpg dim' $USERNAME  # in user script

# Bluetooth applet
systemctl enable bluetooth.service

# Install obsidian
# Cleaning
