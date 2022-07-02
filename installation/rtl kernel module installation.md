`sudo pacman -S dkms`
`git clone -b v5.6.4.2 https://github.com/aircrack-ng/rtl8812au.git`
`cd rtl*`
`sudo make dkms_install`
```
mkdir: created directory '/usr/src/8812au-5.6.4.2_35491.20191025'
cp -r * /usr/src/8812au-5.6.4.2_35491.20191025
dkms add -m 8812au -v 5.6.4.2_35491.20191025
Creating symlink /var/lib/dkms/8812au/5.6.4.2_35491.20191025/source -> /usr/src/8812au-5.6.4.2_35491.20191025
dkms build -m 8812au -v 5.6.4.2_35491.20191025
Error! Your kernel headers for kernel 5.18.7-zen1-1-zen cannot be found at /usr/lib/modules/5.18.7-zen1-1-zen/build or /usr/lib/modules/5.18.7-zen1-1-zen/source.
Please install the linux-headers-5.18.7-zen1-1-zen package or use the --kernelsourcedir option to tell DKMS where it's located.
make: *** [Makefile:2311: dkms_install] Error 1
```
`sudo pacman -S linux-headers`
`sudo make dkms_install`                                                                 
```
cp -r * /usr/src/8812au-5.6.4.2_35491.20191025
dkms add -m 8812au -v 5.6.4.2_35491.20191025
Error! DKMS tree already contains: 8812au-5.6.4.2_35491.20191025
You cannot add the same module/version combo more than once.
make: *** [Makefile:2310: dkms_install] Error 3
```
`sudo make dkms_remove`
```
[sudo] password for arco: 
dkms remove 8812au/5.6.4.2_35491.20191025 --all
Module 8812au-5.6.4.2_35491.20191025 for kernel 5.18.7-arch1-1 (x86_64).
Before uninstall, this module version was ACTIVE on this kernel.

88XXau.ko.zst:
 - Uninstallation
   - Deleting from: /usr/lib/modules/5.18.7-arch1-1/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.
depmod...
Deleting module 8812au-5.6.4.2_35491.20191025 completely from the DKMS tree.
rm -rf /usr/src/8812au-5.6.4.2_35491.20191025
```

`sudo pacman -S linux-zen-headers`
`sudo make dkms_install`          
```
mkdir: created directory '/usr/src/8812au-5.6.4.2_35491.20191025'
cp -r * /usr/src/8812au-5.6.4.2_35491.20191025
dkms add -m 8812au -v 5.6.4.2_35491.20191025
Creating symlink /var/lib/dkms/8812au/5.6.4.2_35491.20191025/source -> /usr/src/8812au-5.6.4.2_35491.20191025
dkms build -m 8812au -v 5.6.4.2_35491.20191025

Building module:
cleaning build area...
'make' -j4 KVER=5.18.7-zen1-1-zen KSRC=/lib/modules/5.18.7-zen1-1-zen/build.................................
cleaning build area...
dkms install -m 8812au -v 5.6.4.2_35491.20191025

88XXau.ko.zst:
Running module version sanity check.
 - Original module
   - No original module exists within this kernel
 - Installation
   - Installing to /usr/lib/modules/5.18.7-zen1-1-zen/updates/dkms/
depmod...
dkms status -m 8812au
8812au/5.6.4.2_35491.20191025, 5.18.7-zen1-1-zen, x86_64: installed
```

I think it's success:D
kernel module for realtek NIC is installed:>

source:
`https://github.com/aircrack-ng/rtl8812au `