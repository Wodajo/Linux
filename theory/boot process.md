BIOS/UEFI -> GRUB/GRUB2 -> kernel -> init (sytstemd) -> rest of system processes

UEFI use `GPT` (GUID (globally unique identifiers) partition table)
min. 300M for `EFI partition` (formatted as FAT32) - place for the EFI bootloaders, applications and drivers to be launched by the UEFI firmware

`GRUB` - harder to make changes
	has `grub.config` file in `/boot/grub`
`GRUB2` - easy configuration via `/etc/default/grub` -> `grub-mkconfig -o /boot/grub/grub.cfg` (`update-grub` is a shell script doing the same)
	has `grub.cfg` file

`ls /boot`
```
initrd.img  # init ram disk - inform kernel which modules it should load
initrd.img-5.13.0.40-generic
config-5.13.0.40-generic  # info about compilation configuration
vmlinuz   # linux kernel. linuz means it's compressed, linux would be not-compressed
vmlinuz-5.13.0.40-generic
System.map-5.13.0.40-generic   # tells system to look into /lib/modules for modules
efi  # efi dir (newer mountpoint would be /efi)
grub  # grub dir
memtest86+.bin
memtest86+.elf
memtest86+_multiboot.bin
```
`ls /lib/modules`
```
5.13.0.40-generic
```
`ls /lib/modules/5.13.0.40-generic`
```
modules.alias
modules.alias.bin
modules.builtin
mudules.dep
modules.dep.bin
modules.devname
modules.order
modules.softdep
modules.symbols
modules.symbols.bin
```
here the modules at