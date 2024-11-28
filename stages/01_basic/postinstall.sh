#!/bin/bash

# Source utils
. ~/archinstall/utils/utils.sh

info "setting pwndbg for gdb"
echo 'source /usr/share/pwndbg/gdbinit.py' >> ~/.gdbinit

info "enable qemu"
sudo systemctl enable libvirtd.service
usermod -aG libvirt-qemu zsidanyi
usermod -aG libvirt zsidanyi

# Setting virtual network for VMs
# virsh net-start default
# virsh net-autostart default
# virsh net-list --all
#
# Adding user to every needed group so no rootpasswd is asked
# usermod -aG libvirt $USER
# usermod -aG libvirt-qemu $USER
# usermod -aG kvm $USER
# usermod -aG input $USER
# usermod -aG disk $USER
