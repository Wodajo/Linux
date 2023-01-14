`adduser user` - script using `useradd`
	automatically set up user, group, home dir, copying files&dirs from `/etc/skel` (e.g. .bashrc, .profile, .Xresources), settin gpassword, full name...

`userdel -r` - delete account with all user files & mail (`/var/mail/user`)

`usermod -s /bin/false user` you can't log in if your shell is `/bin/false`
	`-s` shell. 
`usermod -aG additional_groups user`
	if omitted `-a` option - user is removed from all groups not listed in additional_groups