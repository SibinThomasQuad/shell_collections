#!/bin/bash

# Define the threshold for the number of connections per IP
THRESHOLD=100

# Retrieve the IP addresses with more than the threshold of connections
IP_LIST=$(netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | grep -E "^[1-9][0-9]* " | awk -v limit=$THRESHOLD '$1 > limit {print $2}')

# Block the IP addresses with iptables
for IP in $IP_LIST
do
    iptables -A INPUT -s $IP -j DROP
    echo "Blocked IP address: $IP"
done

# Save the iptables rules to persist through reboots
iptables-save > /etc/iptables/rules.v4
