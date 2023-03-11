`sudo pacman -S qtile lxappearance nitrogen thunar alacritty picom firefox archlinux-wallpaper lightdm lightdm-gtk-greeter nm-applet`

`lxappaerance` - can now change, at once, details such as icons, controls, colours, mouse cursors and window decoration
`nitrogen` - fast and lightweight (GTK2) desktop background browser and setter for X Window
`alacritty` - terminal
`picom` - compositor (without it terminal couldn't be transparent)
`lightdm` - display manager
`lightdm-gtk-greeter` - actual greeter

`nano .xprofile`  .xprofile file contain programs you want to start when you're starting Window Manager
```
setxkbmap pl
nm-applet
nitrogen --restore
picom -f &
```
`setxkbmap pl` keymap, `nitrogen --restore` restore previous wallpaper after reboot, `picom -f &` start compositor with fading effect in the backgroud

BUT it won't work when going out of sleep mode (vpn wth ks won't re-connect) -> use `~/.config/qtile/autostart.sh` (start it with hook from `~/.config/qtile/config.py`)