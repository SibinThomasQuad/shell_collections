#!/bin/bash

echo "Hardening PHP..."
echo ""

# Backup the original php.ini file
sudo cp /etc/php/7.4/apache2/php.ini /etc/php/7.4/apache2/php.ini.orig

# Set PHP configuration settings to harden PHP
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.4/apache2/php.ini
sudo sed -i "s/expose_php = On/expose_php = Off/" /etc/php/7.4/apache2/php.ini

# Restart Apache
sudo systemctl restart apache2

echo "PHP hardened successfully!"
