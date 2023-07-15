#### kali
`sudo apt install awesome awesome-extra rofi nitrogen picom unlcutter xbacklight xsel slock`
	`unclutter` hides mouse when not needed

get `.conifg/awesome/rc.lua` and other stuff (for theming) 

might get used later:
	`amixer dmenu librewolf mpc mpd scrot unclutter xbacklight xsel slock`
		`mpd` - music player daemon
		`mpc` - cli of `mpd`


I tried to create stacking in 2 columns, but sadly `dynamite` source code is nowhere to be found, and lua objects (such as layouts tags) don't simply allow to create sth like this.

Thus I go back to `qtile`, but installed with `nix` because `pip install` is not approved by `python3` upstream anymore