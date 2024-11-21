#!/bin/bash

# Source utils
. ~/archinstall/utils/utils.sh

info "Reload for hotplug-monitor service"
systemctl daemon-reload

info "Enable lightdm Desktop Manager"
systemctl enable lightdm.service
