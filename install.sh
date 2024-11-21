#!/bin/bash

# usage: sudo ./install.sh ./stages/01_basic

# Source utils
. ~/archinstall/utils/utils.sh

# Test for root
if ! [[ $(id -u) = 0 ]]; then
  fatal "Please run as root/sudo!"
fi

if ! [[ -d $1 ]]; then
  fatal "Not a proper dir is provided"
fi

stage_path=$(realpath -s "$1")
echo $stage_path

# 1. Install packages from stage
for pkg_file in $stage_path/*.txt; do
  info "Installing packages: "
  cat $pkg_file | tr '\n' ' '; echo ""
  # Installing the packages
  if ask "Install package `basename $pkg_file`?"; then
    pacman -S --needed --noconfirm - < $pkg_file
  fi
done

# 2. Copy configs found in stage
stage_config=$stage_path/config
if [[ -d $stage_config ]]; then
  cp -R $stage_config/* /
fi

# 3. Run postinstall scripts for the stage
postinstall_script=$stage_path/postinstall.sh
if [[ -f $postinstall_script ]]; then
  echo "Executing postinstall script: $postinstall_script"
  . $postinstall_script
fi

