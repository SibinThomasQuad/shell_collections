#!/bin/bash

# Remove unnecessary packages
sudo apt-get remove -y firefox libreoffice-common thunderbird totem rhythmbox

# Clean up unused dependencies
sudo apt-get autoremove -y

# Disable unused services
sudo systemctl stop cups.service
sudo systemctl disable cups.service

# Install and enable lightweight display manager
sudo apt-get install -y lightdm
sudo systemctl enable lightdm.service

# Switch to a lightweight window manager
sudo apt-get install -y openbox
sudo update-alternatives --set x-window-manager /usr/bin/openbox-session

# Set power management settings to conserve battery
sudo apt-get install -y powertop
sudo powertop --auto-tune

# Disable unnecessary startup programs
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
sudo sed -i 's/Hidden=true/Hidden=false/g' /etc/xdg/autostart/*.desktop

# Remove unused kernel modules
sudo apt-get remove -y linux-image-generic

# Clean up temporary files
sudo apt-get autoclean -y
sudo apt-get clean -y
sudo rm -rf ~/.cache/*

# Reboot to apply changes
sudo reboot
