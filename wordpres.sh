#!/bin/bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install Apache web server
sudo apt install -y apache2

# Install MySQL database server
sudo apt install -y mysql-server

# Install PHP and required extensions
sudo apt install -y php libapache2-mod-php php-mysql php-cli

# Download and extract the latest WordPress release
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz

# Move WordPress files to the web server root directory
sudo cp -R wordpress/* /var/www/html/

# Set ownership and permissions for WordPress files
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Configure MySQL for WordPress
sudo mysql -e "CREATE DATABASE wordpress;"
sudo mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'wppassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Clean up temporary files
rm -rf latest.tar.gz wordpress

# Restart Apache web server
sudo service apache2 restart

