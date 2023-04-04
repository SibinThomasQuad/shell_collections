#!/bin/bash

# Backup the user's home directory
tar -czvf user_backup.tar.gz /home/user

# Create a list of installed packages
dpkg --get-selections > package_list.txt

# Copy the backup archive and package list to the new machine
scp user_backup.tar.gz package_list.txt user@newmachine:/tmp/

# Install the packages on the new machine
ssh user@newmachine "sudo dpkg --set-selections < /tmp/package_list.txt && sudo apt-get dselect-upgrade -y"

# Extract the backup archive on the new machine
ssh user@newmachine "sudo tar -xzvf /tmp/user_backup.tar.gz -C /home/"

# Set ownership and permissions of the new home directory
ssh user@newmachine "sudo chown -R user:user /home/user && sudo chmod -R 755 /home/user"
