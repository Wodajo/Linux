#!/usr/bin/env bash
# Programs starting with Qtile

nm-applet &
nmcli connection delete pvpn-ipv6leak-protection &
nmcli connection delete pvpn-killswitch &
setxkbmap pl &
nitrogen --restore &
picom -f &
protonvpn-cli c -f &
blueman-applet &
