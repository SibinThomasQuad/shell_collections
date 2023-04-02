#!/bin/bash

# Install MySQL server
sudo apt-get update
sudo apt-get install mysql-server

# Create a new database and tables as necessary
sudo mysql -u root -p -e "CREATE DATABASE mydatabase;"
sudo mysql -u root -p mydatabase < /path/to/sql/file.sql

# Create a user for replication and grant permissions
sudo mysql -u root -p << EOF
CREATE USER 'replication_user'@'%' IDENTIFIED BY '<password>';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
FLUSH PRIVILEGES;
EOF

# Enable binary logging and get the log file and position
sudo sed -i 's/#server-id       = 1/server-id       = 1/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i 's/#log_bin         = /var/log/mysql/mysql-bin.log/log_bin         = /var/log/mysql/mysql-bin.log/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
MASTER_LOG_FILE=$(sudo mysql -u root -p -e "SHOW MASTER STATUS\G" | awk '/File/ {print $2}')
MASTER_LOG_POS=$(sudo mysql -u root -p -e "SHOW MASTER STATUS\G" | awk '/Position/ {print $2}')

# Display the log file and position to be used when setting up the slave server
echo "Master Log File: $MASTER_LOG_FILE"
echo "Master Log Position: $MASTER_LOG_POS"
