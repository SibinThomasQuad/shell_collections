#!/bin/bash

# Backup the original MySQL configuration file
sudo cp /etc/my.cnf /etc/my.cnf.bak

# Open the MySQL configuration file
sudo nano /etc/my.cnf

# Add the following lines under the [mysqld] section
echo "[mysqld]
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
query_cache_size = 64M
thread_cache_size = 8
max_connections = 100
key_buffer_size = 64M" | sudo tee -a /etc/my.cnf

# Restart MySQL
sudo systemctl restart mysqld
