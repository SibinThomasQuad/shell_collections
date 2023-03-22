#!/bin/bash

echo "Creating a new proxy server..."
echo ""

# Install Squid
apt-get update
apt-get install squid -y

# Configure Squid
cat << EOF > /etc/squid/squid.conf
http_port 3128
acl localnet src 192.168.0.0/16
http_access allow localnet
http_access allow localhost
http_access deny all
EOF

# Restart Squid
systemctl restart squid

echo "Proxy server created successfully!"
