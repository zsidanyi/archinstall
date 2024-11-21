#!/bin/bash

# Source utils
. ~/dotfiles/scripts/utils.sh

info "Reload for hotplug-monitor service"
systemctl daemon-reload

info "Enable lightdm Desktop Manager"
systemctl enable lightdm.service
