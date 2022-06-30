`sudo pacman -S qtile lxappearance nitrogen thunar xfce4-terminal picom firefox archlinux-wallpaper lightdm lightdm-gtk-greeter`

`lxappaerance` - can now change, at once, details such as icons, controls, colours, mouse cursors and window decoration
`nitrogen` - fast and lightweight (GTK2) desktop background browser and setter for X Window
`xfce4-terminal` - for now, later alacritty
`picom` - compositor (without it terminal couldn't be transparent)
`lightdm` - display manager

`nano .xprofile`  .xprofile file contain programs you want to start when you're starting Window Manager
```
setxkbmap pl
nitrogen --restore
picom -f &
```
`setxkbmap pl` keymap, `nitrogen --restore` restore previous wallpaper after reboot, `picom -f &` start compositor with fading effect in the backgroud

