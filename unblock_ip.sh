#!/bin/bash

# Set the IP address to unblock
IP_ADDRESS="x.x.x.x"

# Unblock the IP address
sudo iptables -D INPUT -s $IP_ADDRESS -j DROP

# Save the iptables configuration
sudo /sbin/iptables-save

