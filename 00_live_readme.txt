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
# pacstrap -K /mnt base linux linux-lts linux-firmware
#
# Generate filesystem table to automount next time
# genfstab -U /mnt >> /mnt/etc/fstab
#
# Chroot to installation
# arch-chroot /mnt
#
# After chroot
# pacman -S vim git
# cd; git clone https://github.com/zsidanyi/archinstall.git
