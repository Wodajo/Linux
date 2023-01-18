#! /usr/bin/env bash
# For base installation of Arch
# 
# there is also chroot.sh for system-wide configs
# and user.sh for user-specific stuff


# For storage devices display you can also: lsblk
fdisk -l

read -p "Enter the name of the disk you want to partition (e.g. sda): " DISK

echo "[+] setting timezone"
timedatectl set-timezone Europe/Warsaw

echo "[+] partitioning"
# Start fdisk on the selected disk
fdisk /dev/$DISK
# Create a new GPT partition table
g
# Create a new partition for the ESP (EFI system partition
n  # new partition
1  # partition number
/n  # first sector
+300M  # last sector
t  # change partition type
1  # EFI System
# Create a new partition for the swap space
n
2
/n
+8.8G
t
19
# Create a new partition for the root dir
n
3
/n
/n
t
23
# Print partition table
p
# Save and exit fdisk
w

echo "[+] formatting partitions"
mkfs.fat -F 32 /dev/${DISK}1
mkswap /dev/${DISK}2
mkfs.ext4 /dev/${DISK}3

echo "[+] mounting"
mount /dev/${DISK}3 /mnt
mount --mkdir /dev/${DISK}1 /mnt/boot
swapon /dev/${DISK}2

echo "[+] reflector"
pacman -Sy reflector --needed --noconfirm
reflector --country Poland,Germany  --sort rate --save /etc/pacman.d/mirrorlist

echo "[+] install base linux & linux-firmware"
pacstrap /mnt base linux linux-firmware

echo "[+] generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "[+] copy chroot.sh to chroot -> execute in chroot"
cp chroot.sh /mnt/home/
arch-chroot /mnt bash /home/chroot.sh

echo "[+] chroot.sh finished"
rm /mnt/home/chroot.sh
echo "### base install (base_install.sh&chroot.sh) completed! ###"
echo "you can reboot and remove intalation media"
