#!/usr/bin/env bash

# Skript for Qtile on kali machine - try without any DE
# This part is to be run per-user

echo "[+] Installing qtile & cairocffi"
pip install --no-cache-dir cairocffi
pip install psutil
pip install qtile


# Create .zshenv (for XDG env specification of each zsh session)
whoami
cat <<- _EOF_ > ~/.zshenv
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

source ~/.zshenv

# Make directories for config files
mkdir -p $XDG_CONFIG_HOME/qtile
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/rofi

# Copy config files
cp -r config/qtile/* $XDG_CONFIG_HOME/qtile/  # config.py & autostart.sh
cp -r config/alacritty/* $XDG_CONFIG_HOME/alacritty/  # alacritty.yml
cp -r config/rofi/* $XDG_CONFIG_HOME/rofi/  # rofi.rasi & Monokai.rasi
#cp config/picom.conf ~/.config  - you can mess with shadows and stuff later
