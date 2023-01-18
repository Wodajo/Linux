#! /usr/bin/env bash
# chroot part of basic installation

echo "[+] time zome, locale, keymap"
ln -sf /usr/share/zoneinfo/Poland /etc/localtime
hwclock --systohc
sed -i 's/#pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo 'LANG=pl_PL.UTF-8' > /etc/locale.conf
echo "KEYMAP=pl" >> /etc/vconsole.conf

echo "[+] network configuration"
echo "Neurocranium" >> /etc/hostname
cat <<- _EOF_ > /etc/hosts
127.0.0.1	localhost
#127.0.0.1	hostname  # for systems with static IP

# The following lines are desirable for IPv6 capable host
::1	localhost ip6-localhost ip6-loopback
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
_EOF_

echo "[+] set root pwsswd"
passwd
useradd -m arco
echo "[+] set arco passwd"
passwd arco

echo "[+] bootloader"
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg


# pacman -S iproute2 networkmanager cups foomatic-* ghostscript gutenprint
# sed add lpadmin to SystemGroup
# usermod -aG wheel lpadmin arco


# systemctl enable cups (maybe qtile root conf sh here? :D
# systemctl enable NetworkManager

# visudo for arco
