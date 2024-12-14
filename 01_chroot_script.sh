#!/bin/bash

# Source utils
. ~/archinstall/utils/utils.sh

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
pacman -S --needed --noconfirm - < $(dirname "$0")/stages/00_chroot/00_live_chroot.txt

if ask "Install grub?"; then
  grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot \
    --bootloader-id=GRUB

  cp --verbose -R $(dirname "$0")/stages/00_chroot/config/* /

  grub-mkconfig -o /boot/grub/grub.cfg
fi

info "setup finished; reboot into arch and continue with next setup script"

