[arch wiki](https://wiki.archlinux.org/title/Installation_guide)

###### kayboard layout
available layouts:
`ls /usr/share/kbd/keymaps/**/*.map.gz`

pass layout with `loadkeys` (omit extension):
`loadkeys pl`
works only for a session


##### connect to the Internet
check if NIC is listed and enabled:
`ip a`

for WiFi:
Systemd units - `systemd-networkd.service`, `systemd-resolved.service`
	(units can be i.a. services (_.service_), mount points (_.mount_), devices (_.device_) and sockets (_.socket_))
	- `networkctl` as interface
	- should provide **dynamic IP & DNS server** assignments for Ethernet, WLAN, WWAN

Later you can install and enable `NetworkManager` (contains: daemon, cli interface `nmcli`). Systemd unit - `NetworkManager.service`

`iwctl` to get into interactive `iwd` (net wireless daemon)
	on my device it has some wierd problem with connecting to home router, but doesn't with smartphone hot-spot
`device list` list wifi devices (e.g. wlan0)
`station wlan0 scan` no output, but it works
`station wlan0 get-networks`
`station wlan0 connect SSID` wierd errors during connecting with my home router happens. But connecting with hot-spots seems fine. wierd


##### set system clock
`timedatectl set-time "2012-10-30 18:17:16"` 
`timedatectl set-timezone Europe/Warsaw`
`timedatectl status`:
	localtime - depends of current *time zone*
	UTC *Universal Tme Coordinated* - global time standard, independent of time zones (Poland in UTC + 1 in winter, +2 in summer)
	RTC - *Real Time Cock* hardware clock working indepedntly of system state
	NTP *Network Time Protocol* - time synchro over networktimedat


### Partitioning
##### disks partitioning using fdisk
By live system disks are recognized as block devices (e.g. `/dev/sda`, `/dev/nvme0n1`)
`fdisk -l`  to idntify these devices
results ending with `rom`, `loop` and `airloot` may be ignored

`fdisk /dev/disk_to_be_partitioned`
	`g`  new GPT partition table
		UEFI use GPT aka GUID (globally unique identifiers) partition table
	`n` new partition (we need at least one for root dir & EFI system partition)
		- ESP (EFI system partition)
		`1` partition number
		`/n` default first sector
		`+300M`
		`t` to enter partition type
		`1` "Efi System"
		- Linux swap
		`2`
		`/n`
		`+9G`
		`t`
		`19`
		- Linux x86-64 root (/)
		`3`
		`/n`
		`/n`
		`t`
		`23`
	`p` print
	`w` write

###### disk partitioning using parted - not tested!
`parted /dev/disk_to_part mkpart "EFI system partition" fat32 1MiB 301MiB`
	this doesn't format partition (only "EFI.." label and "fat32" type)
`parted /dev/disk_to_part set 1 esp on`
	set the partition flag "esp" (EFI system partition) on the first partition of the specified disk
`parted /dev/disk_to_part mkpart "swap partition" linux-swap 301MiB 9GiB`
`parted /dev/disk_to_part mkpart "root partition" ext4 9GiB 100%`

##### format partitions with appropriate fs
`lsblk -f` to check if sth is mounted. If it is -> UNmount e.g. `umount /dev/sda2`

`mkfs.ext4 /dev/sda3 -L ARCHROOT` to create ext4 fs on sda3 partition
`mkswap /dev/sda2` to initialize swap partition
`mkfs.fat -F 32 /dev/sda1` format EFI partition to FAT32
`fatlabel /dev/sda1 ARCHBOOT`

##### mount fs
`mount /dev/sda3 /mnt` to mount root volume to `/mnt`
If I get it correctly - current (live systems) `/mnt` will be future `/`
`mount --mkdir /dev/sda1 /mnt/boot` to create `/mnt/boot` and mount EFI partition there
`swapon /dev/sda2` to enable swap volume

##### installation
mirrors servers in `/etc/pacman.d/mirrorlist`.

On live system after connecting to Internet `reflector` (python script) updates mirror choosing 20 most **recently sync. HTTPS mirrors & sorti**ng them by download rate.

`pacstrap /mnt base linux linux-firmware` 
`pacstrap` (python script) install packages to the specified new root dir.
By default the host system's pacman signing keys and mirrorlist will be used to seed the chroot.
You can omit `linux-firmware` if in VM or container

`genfstab -U /mnt >> /mnt/etc/fstab` 
generate `fstab` file - define how disk partitions, other block devices or remote file systems should be mounted to file system.
During boot OR system manager configuration reload -> `fstab` definitions converted into `systemd` mount units.

##### basic configuration
Chroot (change root) into the new system:
`arch-chroot /mnt`

`pacman -S nano`
Locales - used by locale-aware programs (i.a. time and date formats, alphabetic idiosyncrasies)
`nano /etc/locale.gen` 
locales are in form *language_territory.codeset*
uncomment `pl_PL.UTF-8` 
`locale-gen` to apply changes.

Make [[#kayboard layout]] persistent:
`nano /etc/vconsole.conf`
append `KEYMAP=pl`

##### basic network configuration
`echo "Neocortex" >> /etc/hostname`  to create hostname

`nss-myhostname` - (NSS is a module provided by `systemd`) provides local hostname resolution without eiditing `/etc/hosts`
BUT
Some software still read `/etc/hosts` directly
So  `nano /etc/hosts` 
```
127.0.0.1        localhost
#127.0.1.1        _myhostname_ # for systems with permanent IP
#203.0.113.45 host1.fqdm.example host1 #for a system with a FQDM

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

`pacman -S iproute2` - `ip n`, `ip a`, `ss`, `ip r` (insted of depreciated `arp`, `ifconfig`, `netstat`, `route`)

`pacman -S networkmanager` - DHCP client, `nmcli`, `nmtui`
`systemctl enable NetworkManager` to start nm at boot



##### basic user conf
`passwd root`
`useradd -m arco`
`passwd arco`

`pacman -S sudo`
`EDITOR=nano visudo`
add regular user to wheel group (better than sudoers grup, bcos polkit treats wheel as admins - will always ask about user passwd and not root)
`usermod -aG wheel arco`


##### bootloader
`pacman -S grub efibootmgr`
`GRUB` is the bootloader, `efibootmgr` is used by GRUB installation script to write entries to NVRAM (non-volatile RAM, it don't loose data if power is down)
`grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`

To apply microcode (stability and security updates to the processor microcode):
`pacman -S intel-ucode`
microcode must be loaded by boot loader
To re-run configuration script generation (after adding, removing kernel or enabling microcode):
`grub-mkconfig -o /boot/grub/grub.cfg`


##### printing

1. app sends PDF to CUPS (if it's not PDF it's changed into PDF)
2. CUPS looks at the printer's PPD file (printer description file) and figures out what filters it needs to use to convert the PDF file to a language that the printer understands (like PJL, PCL, bitmap or native PDF)
3. filter converts the PDF file to a format understood by the printer
4. it is sent to the back-end. For example, if the printer is connected to a USB port, it uses the USB back-end

`pacman -S cups foomatic-db ghostscript gsfonts gutenprint foomatic-db-gutenprint-pdds`
	`cups` - current standards-based, open source printing system, `foomatic` - provides PPDs for many printer drivers, `ghostscript` - for non-PDF printers, `gutenprint` - drivers for Canon, Epson, Lexmark, Sony, Olympus, and PCL printers for use with CUPS and GIMP  
	**You might have to check for PDD on producer site or in AUR**

`vim /etc/cups/cups-files.conf`
```
SystemGroup root lpadmin  # add `lpadmin` group
```

`usermod lpadmin arco`
`sudo systemctl enable cups`
`127.0.0.1:631` CUPS web interface