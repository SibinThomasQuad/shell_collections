#!/bin/bash

# Set the desired swap file size in gigabytes
SWAP_SIZE_GB=4

# Calculate the size in bytes
SWAP_SIZE_BYTES=$((SWAP_SIZE_GB*1024*1024*1024))

# Check if swap file already exists
if grep -q "swapfile" /etc/fstab; then
    echo "Swap file already exists. Removing old swap file..."
    sudo swapoff /swapfile
    sudo rm /swapfile
fi

# Create new swap file
echo "Creating new swap file of size ${SWAP_SIZE_GB}GB..."
sudo dd if=/dev/zero of=/swapfile bs=1G count=${SWAP_SIZE_GB}
sudo chmod 600 /swapfile

# Enable new swap file
echo "Enabling new swap file..."
sudo mkswap /swapfile
sudo swapon /swapfile

# Update fstab file to make swap file permanent
echo "Updating /etc/fstab to make swap file permanent..."
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# Verify the new swap space
echo "Swap space has been increased. The following is the output of the 'free' command:"
free -h
