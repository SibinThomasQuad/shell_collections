#!/bin/bash

# Function to prompt for user input with default value
prompt_with_default() {
    read -p "$1 (default: $2): " value
    value=${value:-$2}
    echo "$value"
}

# Stop Apache before making changes
service apache2 stop

# Backup the original Apache configuration
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.backup

# Prompt for user input or provide default values
max_clients=$(prompt_with_default "Enter the maximum number of clients (concurrent connections)" "150")
start_servers=$(prompt_with_default "Enter the number of starting server processes" "5")
min_spare_servers=$(prompt_with_default "Enter the minimum number of spare server processes" "5")
max_spare_servers=$(prompt_with_default "Enter the maximum number of spare server processes" "10")
server_limit=$(prompt_with_default "Enter the server limit (maximum value for MaxRequestWorkers)" "150")

# Update Apache configuration with user-provided values
sed -i "s/MaxClients.*/MaxClients $max_clients/" /etc/apache2/apache2.conf
sed -i "s/StartServers.*/StartServers $start_servers/" /etc/apache2/apache2.conf
sed -i "s/MinSpareServers.*/MinSpareServers $min_spare_servers/" /etc/apache2/apache2.conf
sed -i "s/MaxSpareServers.*/MaxSpareServers $max_spare_servers/" /etc/apache2/apache2.conf
sed -i "s/ServerLimit.*/ServerLimit $server_limit/" /etc/apache2/apache2.conf

# Start Apache after making changes
service apache2 start

echo "Apache tuning completed."
