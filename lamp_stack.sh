#!/bin/bash

# Update the package list and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Install MySQL and secure the installation
sudo apt install mysql-server -y
sudo mysql_secure_installation

# Install PHP and some commonly used PHP modules
sudo apt install php libapache2-mod-php php-mysql php-cli php-gd php-imagick php-recode php-tidy php-xmlrpc php-curl php-intl php-mbstring php-soap php-xml php-zip -y

# Enable Apache modules
sudo a2enmod rewrite
sudo systemctl restart apache2

# Create a PHP info file to test the installation
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Open the PHP info file in a web browser to verify the installation
xdg-open http://localhost/info.php
