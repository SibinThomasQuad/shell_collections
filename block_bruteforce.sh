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

# Install fail2ban if not already installed
if ! [ -x "$(command -v fail2ban-client)" ]; then
  apt-get install -y fail2ban
fi

# Configure fail2ban to monitor SSH login attempts
cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

# Restart fail2ban to apply the configuration changes
service fail2ban restart
