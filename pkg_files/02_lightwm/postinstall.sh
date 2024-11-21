#!/bin/bash

# Source utils
. ~/dotfiles/scripts/utils.sh

info "Enable lightdm Desktop Manager"
systemctl enable lightdm.service
