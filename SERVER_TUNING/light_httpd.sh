#!/bin/bash

# Function to prompt for user input with default value
prompt_with_default() {
    read -p "$1 (default: $2): " value
    value=${value:-$2}
    echo "$value"
}

# Stop Lighttpd before making changes
service lighttpd stop

# Backup the original Lighttpd configuration
cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.backup

# Prompt for user input or provide default values
server_modules=$(prompt_with_default "Enter the list of server modules to load (comma-separated)" "mod_access, mod_alias, mod_compress")
max_connections=$(prompt_with_default "Enter the maximum number of connections" "1024")
max_connections_per_ip=$(prompt_with_default "Enter the maximum number of connections per IP" "8")

# Update Lighttpd configuration with user-provided values
sed -i "s/server.modules.*/server.modules = ($server_modules)/" /etc/lighttpd/lighttpd.conf
sed -i "s/server.max-connections.*/server.max-connections = $max_connections/" /etc/lighttpd/lighttpd.conf
sed -i "s/server.max-connections-per-ip.*/server.max-connections-per-ip = $max_connections_per_ip/" /etc/lighttpd/lighttpd.conf

# Start Lighttpd after making changes
service lighttpd start

echo "Lighttpd tuning completed."
