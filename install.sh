#!/bin/bash

# usage: sudo ./pkginst.sh ./pkg_files/01_basic

# Source utils
. ~/dotfiles/scripts/utils.sh

# Test for root
if ! [[ $(id -u) = 0 ]]; then
  fatal "Please run as root/sudo!"
fi

if ! [[ -d $1 ]]; then
  fatal "Not a proper dir is provided"
fi

pkgfiles_path=$(realpath -s "$1")
echo $pkgfiles_path

for pkg_file in $pkgfiles_path/*; do

  if [[ `basename $pkg_file` = "postinstall.sh" ]]; then
    echo "Executing postinstall: $pkg_file"
    . $pkg_file
    continue
  fi

  info "Installing packages: "
  cat $pkg_file | tr '\n' ' '; echo ""
  # Installing the packages
  if ask "Install `basename $pkg_file`?"; then
    pacman -S --needed --noconfirm - < $pkg_file
  fi
done
