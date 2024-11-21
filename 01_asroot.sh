#!/bin/bash

# Source utils
. ~/dotfiles/scripts/utils.sh

# Test for root
if ! [[ $(id -u) = 0 ]]; then
  fatal "Please run as root/sudo!"
fi

echo "Enabling DHCP"
systemctl start dhcpcd.service
systemctl enable dhcpcd.service

if ask "Set new user?"; then
  # Ask for username with default
  read -p "username[zsidanyi]: " username
  username=${username:-zsidanyi}

  useradd -m -G wheel $username
  passwd $username

  # Uncomment sudo line for group wheel
  sed -i 's/^# \(%wheel.*) ALL$\)/\1/' /etc/sudoers
fi

# MANUAL FONT INSTALLATION
# mkdir -p ~/.local/share/fonts/ttf/CousineNerdFontMono
# unzip ~/dotfiles/lfs_artifacts/terminal_font/CousineNerdFontMono.zip -d ~/.local/share/fonts/ttf/CousineNerdFontMono
# chmod 444 ~/.local/share/fonts/ttf/CousineNerdFontMono/*
# fc-cache
#
# To check all the nerdfonts available, start installing nerdfont group from extra
# sudo pacman -S nerd-fonts
