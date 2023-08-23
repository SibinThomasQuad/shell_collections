#!/bin/bash

# Function to prompt for user input with default value
prompt_with_default() {
    read -p "$1 (default: $2): " value
    value=${value:-$2}
    echo "$value"
}

# Stop NGINX before making changes
service nginx stop

# Backup the original NGINX configuration
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Prompt for user input or provide default values
num_processes=$(prompt_with_default "Enter the number of worker processes (controls CPU usage)" "auto")
max_connections=$(prompt_with_default "Enter the maximum number of connections per worker (limits concurrent connections)" "1024")
keepalive_timeout=$(prompt_with_default "Enter the keepalive timeout (time a connection is kept open)" "65")
keepalive_requests=$(prompt_with_default "Enter the keepalive requests (maximum requests per keepalive connection)" "100")

# Update NGINX configuration with user-provided values
sed -i "s/worker_processes.*/worker_processes $num_processes;/" /etc/nginx/nginx.conf
sed -i "s/worker_connections.*/worker_connections $max_connections;/" /etc/nginx/nginx.conf
sed -i "s/keepalive_timeout.*/keepalive_timeout $keepalive_timeout;/" /etc/nginx/nginx.conf
sed -i "s/keepalive_requests.*/keepalive_requests $keepalive_requests;/" /etc/nginx/nginx.conf

# Optimize TCP settings (example values, adjust as needed)
echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.conf
echo "net.core.somaxconn = 65535" >> /etc/sysctl.conf
sysctl -p

# Start NGINX after making changes
service nginx start

echo "NGINX tuning completed."
