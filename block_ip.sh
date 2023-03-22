#!/bin/bash

# Set the IP address to block
IP_ADDRESS="x.x.x.x"

# Block the IP address
sudo iptables -A INPUT -s $IP_ADDRESS -j DROP

# Save the iptables configuration
sudo /sbin/iptables-save

