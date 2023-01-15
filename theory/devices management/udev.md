user-space device manager

use `sysfs` virtual filesystem -> info about hardware
`rules` - for consistent names sake
	e.g. storage devices are having names NOT based on mounting order but sth more specific
	  (that way it won't get messy boot in different order)

`sudo udevadm info /dev/sr0`
	`info` - query `sysfs` or `udev database`
	`/dev/sr0` DVD drive