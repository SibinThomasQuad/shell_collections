#!/bin/bash

# Step 1: Install Apache
sudo apt update
sudo apt install apache2

# Step 2: Configure Apache
echo "<VirtualHost *:80>
    ServerName your-onion-site
    DocumentRoot /var/www/your-onion-site

    <Directory /var/www/your-onion-site>
        AllowOverride All
    </Directory>
</VirtualHost>" | sudo tee /etc/apache2/sites-available/your-site.conf

sudo a2ensite your-site.conf

# Step 3: Install and Configure Tor
sudo apt install tor

echo "HiddenServiceDir /var/lib/tor/your-onion-site
HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc

sudo service tor restart

# Step 4: Publish the Onion Website
sudo cat /var/lib/tor/your-onion-site/hostname

# Step 5: Start Apache
sudo service apache2 start
