#!/bin/bash

# Step 1: Install Nginx
sudo apt update
sudo apt install nginx

# Step 2: Configure Nginx
echo "server {
    listen 80;
    server_name your-onion-site;

    location / {
        root /var/www/your-onion-site;
        index index.html;
    }
}" | sudo tee /etc/nginx/sites-available/your-site.conf

sudo ln -s /etc/nginx/sites-available/your-site.conf /etc/nginx/sites-enabled/

# Step 3: Install and Configure Tor
sudo apt install tor

echo "HiddenServiceDir /var/lib/tor/your-onion-site
HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc

sudo service tor restart

# Step 4: Publish the Onion Website
sudo cat /var/lib/tor/your-onion-site/hostname

# Step 5: Start Nginx
sudo service nginx start
