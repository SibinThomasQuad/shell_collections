#!/bin/bash

# Define the threshold for the number of login attempts per IP
THRESHOLD=3

# Retrieve the IP addresses with more than the threshold of login attempts
IP_LIST=$(grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | awk -v limit=$THRESHOLD '$1 > limit {print $2}')

# Block the IP addresses with iptables
for IP in $IP_LIST
do
    iptables -A INPUT -p tcp -s $IP --dport ssh -j DROP
    echo "Blocked IP address: $IP"
done

# Save the iptables rules to persist through reboots
iptables-save > /etc/iptables/rules.v4
