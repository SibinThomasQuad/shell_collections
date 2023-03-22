#!/bin/bash

# Disable the "test" database
mysql -e "DROP DATABASE IF EXISTS test;"

# Remove anonymous users
mysql -e "DELETE FROM mysql.user WHERE User='';"

# Remove remote root login
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# Change the root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';"

# Disable remote access to the root account
mysql -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'root'@'%';"

# Disable the "LOAD DATA LOCAL" command
mysql -e "SET GLOBAL local_infile = 0;"

# Disable the "symlink" command
mysql -e "SET GLOBAL have_symlink = DISABLE;"

# Restrict the size of the "tmp" directory
mysql -e "SET GLOBAL tmp_table_size = 16M;"

# Enable binary logging
mysql -e "SET GLOBAL log_bin = ON;"

# Restart MySQL
systemctl restart mysql.service
