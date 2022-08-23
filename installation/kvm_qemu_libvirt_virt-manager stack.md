#### key system tools:
- `kvm` (Kernel-based VM) - kernel module that handles `CPU` and `memory` communication (already in kernel)
  
- `qemu` (Quick Emulator) - emulates hardware resources such as `disk`, `network`, and `USB`  
It could emulate `CPU` BUT in that stack I want it to delegate such concerns to `kvm` (that's [hardware-assisted virtualization](https://en.wikipedia.org/wiki/Hardware-assisted_virtualization))

- `libvirt`  - API between virtualization technologies (i.a. `qemu/kvm`, `hyperV`, `xen`) and `client tools`


#### client tools

- `virsh` - cli tool for communication with `libvirt` 
- `virt-manager` - contains `VNC` and `SPICE` for remote-display of VMs
	`virt-install` - helper tools for creating new VMs
	`virt-viewer` - UI for interacting with VMs via `VNC`/`SPICE`

#### auxillary system tools

-   `dnsmasq` - light-weight DNS/DHCP server. Mainly for allocating IPs to VMs
-   `dhclient` - DHCP resolution
-   `dmidecode` - prints computers SMBIOS table in readable format
-   `iptables-nft` - used for setting up NAT networking the host
-   `bridge-utils` - used to create bridge interfaces easily. (depreciated since 2016 but still in use)
-   `gnu-netcat` - remote management over SSH
  (if don't work as expected - try switching to `openbsd-netcat`)



#### installation
`pacman -S --needed qemu-desktop libvirt virt-manager virt-install virt-viewer dnsmasq dhclient dmidecode iptables-nft gnu-netcat bridge-utils`
there are other potentially desired packages (like `qemu` packages for specific protocols support)
`qemu-base` - headless
`qemu-desktop` - x86_64 architecture emulation
`qemu-emulators-full` - all suported architectures

#### libvirt URI
`qemu:///system`, `qemu:///session` 
[about differences of above](https://blog.wikichoon.com/2016/01/qemusystem-vs-qemusession.html)

you can access qemu VM on `remote` machine e.g. via ssh `qemu://arco@192.168.1.101/system`

`qemu:///system` - local access (with root) - default for `virt-manager`
`qemu:///session` - rootless - default for `virsh`

- Default `client tools` to one URI via `libvirt.conf`:

copy default `libvirt` config to user `.config`
`sudo cp -rv /etc/libvirt/libvirt.conf ~/.config/libvirt/`

`sudo chown USER:GROUP ~/.config/libvirt/libvirt.conf`
uncomment last entry and change how you like


#### managing libvirt
as always `sudo systemctl start libvirtd`

 `/var/lib/libvirt` is a default dir for images, iso's and so on (but you can use whatever you'd like)

To activate a network `virsh net-start NetName`
`NetName` is "`default`" if you don't change/make new one


#### virsh commands
`virsh list` - running VMs
`virsh list --all` - all VMs
`virsh net-start default`

#### virt-install
automate installation with script
```
virt-install \
  --name Kali2 \
  --ram 2048 \
  --disk path=/var/lib/libvirt/images/kali.qcow2,size=8 \
  --vcpus 2 \
  --os-type linux \
  --os-variant generic \
  --console pty,target_type=serial \
  --cdrom /var/lib/libvirt/isos/kali2022.3-amd64.iso
```

#### virt-clone
```
virt-clone \
  --original Kali2 \
  --name Kali3 \
  --file /var/lib/libvirt/images/kali2.qcow2
```

#### bridged network

[Manual (not done yet)](https://joshrosso.com/docs/2020/2020-11-13-vm-networks/)