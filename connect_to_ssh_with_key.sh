#!/bin/bash

# Get the SSH server IP address or domain name
echo "Enter the SSH server IP address or domain name:"
read SSH_SERVER

# Get the path to the key file
echo "Enter the path to the key file:"
read KEY_FILE_PATH

# Connect to the SSH server using the key file
ssh -i $KEY_FILE_PATH $SSH_SERVER
