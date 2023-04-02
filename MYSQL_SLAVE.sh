#!/bin/bash

# Install MySQL server
sudo apt-get update
sudo apt-get install mysql-server

# Create a user for replication and grant permissions
sudo mysql -u root -p << EOF
CREATE USER 'replication_user'@'%' IDENTIFIED BY '<password>';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
FLUSH PRIVILEGES;
EOF

# Stop MySQL server and clear data directory
sudo service mysql stop
sudo rm -rf /var/lib/mysql/*

# Configure slave server
sudo sed -i 's/#server-id       = 1/server-id       = 2/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i 's/#log_bin         = /var/log/mysql/mysql-bin.log/log_bin         = /var/log/mysql/mysql-bin.log/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql start

# Set up replication with the master server
sudo mysql -u root -p << EOF
STOP SLAVE;
CHANGE MASTER TO
MASTER_HOST='<master_ip>',
MASTER_USER='replication_user',
MASTER_PASSWORD='<password>',
MASTER_LOG_FILE='<master_log_file>',
MASTER_LOG_POS=<master_log_pos>;
START SLAVE;
EOF

# Verify replication status
sudo mysql -u root -p -e "SHOW SLAVE STATUS \G"
