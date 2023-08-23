#!/bin/bash

# Function to prompt for user input with default value
prompt_with_default() {
    read -p "$1 (default: $2, current: $3): " value
    value=${value:-$2}
    echo "$value"
}

# Function to extract current value from configuration file
get_current_value() {
    current_value=$(grep -oP "(?<=^$1\s*=\s*)\S+" $2)
    echo "$current_value"
}

# Backup the original MySQL configuration
cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.backup

# Existing values
current_max_connections=$(get_current_value "max_connections" /etc/mysql/mysql.conf.d/mysqld.cnf)
current_key_buffer_size=$(get_current_value "key_buffer_size" /etc/mysql/mysql.conf.d/mysqld.cnf)
current_query_cache_size=$(get_current_value "query_cache_size" /etc/mysql/mysql.conf.d/mysqld.cnf)
current_innodb_buffer_pool_size=$(get_current_value "innodb_buffer_pool_size" /etc/mysql/mysql.conf.d/mysqld.cnf)

# Prompt for user input or provide default values
max_connections=$(prompt_with_default "Enter the maximum number of connections" "100" "$current_max_connections")
key_buffer_size=$(prompt_with_default "Enter the key buffer size (e.g., 256M)" "128M" "$current_key_buffer_size")
query_cache_size=$(prompt_with_default "Enter the query cache size (e.g., 64M)" "0" "$current_query_cache_size")
innodb_buffer_pool_size=$(prompt_with_default "Enter the InnoDB buffer pool size (e.g., 1G)" "128M" "$current_innodb_buffer_pool_size")

# Update MySQL configuration with user-provided values
sed -i "s/max_connections.*/max_connections=$max_connections/" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s/key_buffer_size.*/key_buffer_size=$key_buffer_size/" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s/query_cache_size.*/query_cache_size=$query_cache_size/" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s/innodb_buffer_pool_size.*/innodb_buffer_pool_size=$innodb_buffer_pool_size/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL after making changes
service mysql restart

echo "MySQL tuning completed."
