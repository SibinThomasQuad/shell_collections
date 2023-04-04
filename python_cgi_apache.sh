#!/bin/bash

# Install required packages
sudo apt update
sudo apt install apache2 libapache2-mod-python -y

# Enable CGI module
sudo a2enmod cgi

# Restart Apache
sudo systemctl restart apache2

# Configure Apache to allow Python CGI scripts
sudo echo "<Directory /var/www/html>
Options +ExecCGI
AddHandler cgi-script .py
</Directory>" | sudo tee /etc/apache2/conf-available/python-cgi.conf

# Enable the configuration
sudo a2enconf python-cgi

# Restart Apache
sudo systemctl restart apache2
