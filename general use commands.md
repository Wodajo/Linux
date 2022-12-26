`ss -lntu`
	`-l` listening sockets, `-n`  show port nr, `-t` TCP, `-u` UDP

### git
`git config --global user.name "Username"`
`git config --global user.email "your@mail.bycz"`
`git config -l`
`git config --global credential.helper cache`
`git config --global --unset credential.helper`

### printing settings
`system-config-printer` (gtk gui)
`127.0.0.1:631` CUPS web interface

### Mic & speaker
`alsamixer` - F5 for all devices
`pavucontrol`

### keymaps
list keycodes
`dumpkeys -l`
you can remap keycodes
e.g. switch `CapsLock` with `Escape` (for nvim)
```
keycode 1 = Caps_Lock
keycode 58 = Escape
```
be carefull with gamesxD (it's probably better to just remap nvim keybindings)
`loadkeys /usr/local/share/kbd/keymaps/personal.map`

### tar
`tar -cvf ARCHIVE_NAME WHAT_TO_PUT_THERE`
`-c` create

`tar -rvf ARCHIVE_NAME WHAT_TO_APPEND`

`tar -tf ARCHIVE`
`-t` list

`tar -ztf ARCHIVE`
`-z` passes through gzip -> can list even compressed archives

`tar -xf ARCHIVE`
`-x` extract archive. Autodetect compression type

### 