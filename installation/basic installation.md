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
DHCP - `systemd-networkd` system daemon Network Manager. Should automatically provide **dynamic IP & DNS server** assignments for Ethernet, WLAN, WWAN. Contain cli interface - `networkctl`.  Systemd units - `systemd-networkd.service`, `systemd-resolved.service`
(units can be i.a. services (_.service_), mount points (_.mount_), devices (_.device_) and sockets (_.socket_))

Later you can install and enable `NetworkManager` (contains: daemon, cli interface `nmcli`). Systemd unit - `NetworkManager.service`


`iwctl` to get into interactive `iwd` (net wireless daemon)
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
 
##### disks partiton
By live system disks are recognized as block devices (e.g. `/dev/sda`, `/dev/nvme0n1`)
`fdisk -l`  to idntify these devices
results ending with `rom`, `loop` and `airloot` may be ignored

`fdisk /dev/dik_to_be_partitioned`
You must create at least partition for root directory and EFI partition (for UEFI)

UEFI use GPT aka GUID (globally unique identifiers) partition table
min. 300M for EFI
Root has a name Linux root (x86-64)

##### format partitions with appropriate fs
EFI partition must contain FAT32

` lsblk -f` to check if sth is mounted. If it is -> UNmount e.g. `umount /dev/sda2`

`mkfs.ext4 /dev/sda3` to create ext4 fs on sda3 partition
`mkswap /dev/sda2` to initialize swap partition
`mkfs.fat -F 32 /dev/sda1` format EFI partition to FAT32


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


##### boot loader
`pacman -S grub efibootmgr`
`GRUB` is the bootloader, `efibootmgr` is used by GRUB installation script to write entries to NVRAM (non-volatile RAM, it don't loose data if power is down)
`grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`

To apply microcode (stability and security updates to the processor microcode):
`pacman -S intel-ucode`
microcode must be loaded by boot loader
To re-run configuration script generation (after adding, removing kernel or enabling microcode):
`grub-mkconfig -o /boot/grub/grub.cfg`


