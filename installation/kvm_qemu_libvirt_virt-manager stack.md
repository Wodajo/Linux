#### key system tools:
- `kvm` (Kernel-based VM) - kernel module that handles `CPU` and `memory` communication (already in kernel)
- `qemu` (Quick Emulator) - emulates hardware resources such as `disk`, `network`, and `USB`  
It could emulate `CPU` BUT in that stack I want it to delegate such concerns to `kvm` (that's [hardware-assisted virtualization](https://en.wikipedia.org/wiki/Hardware-assisted_virtualization))
- `libvirt`  - API between virtualization technologies (i.a. `qemu/kvm`, `hyperV`, `xen`) and `client tools`


#### client tools
- `virsh` - cli tool for communication with `libvirt` (provided with `libvirt`)
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

`sudo systemctl start libvirtd`

you can access qemu VM on `remote` machine using `libvirt URI` e.g. via ssh `qemu://arco@192.168.1.101/system`

[system vs session connection](https://blog.wikichoon.com/2016/01/qemusystem-vs-qemusession.html)
#### qemu:///system
`qemu:///system` - connects to the **system** libvirtd instance (the one launched by systemd)
   `libvirtd` is running as root -> has access to all host resources
   qemu VMs launched as the unprivileged "qemu" user
   access to root-owned resources mediated by `polkit`
   - daemon config is in `/etc/libvirt`
   - VM logs and stuff are stored in `/var/lib/libvirt`
   - default for `virt-manager`

**Problems**:
app (e.g. `virt-manager`) run as local user (with privileges elevated so as to run `libvirtd`)
BUT
VM run as "qemu" user -> can't access local resources (e.g. `$HOME`)
	To access sth in `$HOME`:
	- `libvirt` has to change the file owner to `qemu:qemu`
	AND
	- `virt-manager` has to give search access to `$HOME` for user `qemu`

**Setup**:
copy default `libvirt` config to user `.config`:
`sudo cp -rv /etc/libvirt/libvirt.conf ~/.config/libvirt/`
`-rv` recursive, verbose

`sudo chown USER:GROUP ~/.config/libvirt/libvirt.conf`
uncomment last entry to default client tools to `qemu:///system`

#### qemu:///session
 `qemu:///session` - Connects to a **session** libvirtd instance running as the user subprocess (daemon is auto-launched if it's not already running)
   libvirt and all VMs run as the app user -> no root password required
   - config, logs and disk images stored in `$HOME` -> each user has their own pool of VMs
   - default for `virsh`, `gnome-boxes`

**Problems**:
nothing in the stack is privileged -> VM tasks that needs host admin privileges won't work -> networking and **host PCI device assignment problems**
	Workaround for privileged networking setup - `setuid`  `qemu-bridge-helper`:
	host admin sets up a bridge -> adds it to a whitelist at `/etc/qemu/bridge.conf` -> it's available for unprivileged qemu instances


**Setup**:
configure `kvm` and enable the `libvirt networking components` via `/etc/libvirt/libvirtd.conf`

``` /etc/libvirt/libvirtd.conf
...
unix_sock_group = 'libvirt'
...
unix_sock_rw_perms = '0770'
...
```
set `UNIX domain socket` ownership to libvirt
set `UNIX socket permission` to read and write.

`usermod -aG libvirt arco`

add user to `/etc/libvirt/qemu.conf`
otherwise, qemu will give a permission denied error when trying to access local drives
```/etc/libvirt/qemu.conf
# Some examples of valid values are:
#
#       user = "qemu"   # A user named "qemu"
#       user = "+0"     # Super user (uid=0)
#       user = "100"    # A user named "100" or a user with uid=100
#
user = "username"

# The group for QEMU processes run by the system instance. It can be
# specified in a similar way to user.
group = "username"
```
Search for `user = "libvirt-qemu"` or `group = "libvirt-qemu"`
uncomment both entries and change `libvirt-qemu` to your username or ID

in `virt-manager` _File_ > _Add Connection_ -> _QEMU/KVM User session_


#### bridged network
[Manual (not done yet)](https://joshrosso.com/docs/2020/2020-11-13-vm-networks/)

#### virsh commands
`virsh list` - running VMs
`virsh list --all` - all VMs
`virsh net-start default` - activate network `default`

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

#### Converting ova archives to qcow
`.ova` - `.vmdk` file, and a `.ovf` file (which is an XML file with information pertaining to the VM, just like qemu XML used for VM settings configuration). **_The only file we care about though is the `.vmdk` file as that is the one with the actual image_**

1.  `tar -xvf original.ova`
2.  `qemu-img convert -O qcow2 original.vmdk original.qcow2`
3.  Run the `qcow2` image in QEMU
4.  If it does not boot, try the other vmdk file if there is one