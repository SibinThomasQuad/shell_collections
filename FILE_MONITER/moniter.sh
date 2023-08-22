#!/bin/bash

# Define the directory to monitor
target_directory="/path/to/your/directory"

# Define the log file
log_file="/path/to/log/file.log"

# Function to install inotify-tools on Ubuntu/Debian
install_inotify_tools_debian() {
    sudo apt-get update
    sudo apt-get install -y inotify-tools
}

# Function to install inotify-tools on Fedora/RHEL
install_inotify_tools_rhel() {
    sudo dnf install -y inotify-tools
}

# Check the distribution and install inotify-tools if needed
if [ -x "$(command -v inotifywait)" ]; then
    echo "inotify-tools is already installed."
else
    echo "inotify-tools is not installed. Installing..."
    if [ -f /etc/lsb-release ]; then
        install_inotify_tools_debian
    elif [ -f /etc/redhat-release ]; then
        install_inotify_tools_rhel
    else
        echo "Unsupported distribution. Please install inotify-tools manually."
        exit 1
    fi
fi

# Ensure the log file exists or create it
touch "$log_file"

# Monitor the directory for file changes
inotifywait -m -r -e modify,create,delete,move "$target_directory" |
while read -r directory event file; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - $event - $directory$file" >> "$log_file"
done
