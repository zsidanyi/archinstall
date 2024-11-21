#!/bin/bash

# THE FOLLOWING SHOULD BE PERFORMED FROM THE LIVE MEDIUM
# Create partitions with fdisk -> GPT!
# e.g.: fdisk /dev/sda (m for help; g for GPT!)
# sda1 -> 1GB (+1G) - boot partition
# sda2 -> 4GB (+4G) - swap partition (minimum)
# sda3 -> remaining - root partition
# 
# Format the partitions:
# mkfs.fat -F 32 /dev/sda1
# mkswap /dev/sda2
# mkfs.ext4 /dev/sda3
#
# Mount the partitions
# mount /dev/sda3 /mnt
# mount --mkdir /dev/sda1 /mnt/boot
# swapon /dev/sda2
# 
# Install arch with pacstrap script
# pacman-key --init
# pacman-key --populate
# pacstrap -K /mnt base linux linux-firmware
#
# Generate filesystem table to automount next time
# genfstab -U /mnt >> /mnt/etc/fstab
#
# Chroot to installation
# arch-chroot /mnt
#
# After chroot
# pacman-key --init
# pacman-key --populate
# pacman -S vim git
# cd; git clone https://github.com/zsidanyi/dotfiles.git

# Source utils
. ~/dotfiles/scripts/utils.sh

# Test for root
if ! [[ $(id -u) = 0 ]]; then
  fatal "Please run as root/sudo!"
fi

echo "Setting time"
localtime_file=/etc/localtime
if [[ ! -L $localtime_file ]]; then
  ln -sf /usr/share/zoneinfo/Europe/Budapest $localtime_file
  hwclock --systohc
else
  echo "localtime already set: $localtime_file"
fi

echo "Setting language"
localegen_file=/etc/locale.gen
# if there is no uncommented lines in locale.gen language is considered not set
if ! grep "^[^#;]" /etc/locale.gen 1>/dev/null; then
  echo "en_US.UTF-8 UTF-8" >> $localegen_file
  echo "hu_HU.UTF-8 UTF-8" >> $localegen_file
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
else
  info "locale is already set in: $localegen_file"
fi

echo "Setting hostname"
hostname_file=/etc/hostname
if [[ ! -f $hostname_file ]]; then
  read -p "hostname: " hostname
  echo $hostname > $hostname_file
else
  info "hostname is already set in: $hostname_file"
fi

echo "Setting root password"
# NP in status means no passwd is set
if passwd --status | grep -E "NP|L" 1>/dev/null; then
  passwd
else
  info "passwd already set! Use 'passwd -d root' to unset it!"
fi

echo "Installing basic images needed to boot properly from drive"
pacman -Syyu --noconfirm
pacman -S --needed --noconfirm - < $(dirname "$0")/pkg_files/00_live_chroot.txt

if ask "Install grub?"; then
  grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot \
    --bootloader-id=GRUB

  grub-mkconfig -o /boot/grub/grub.cfg
fi

info "setup finished; reboot into arch and continue with next setup script"

