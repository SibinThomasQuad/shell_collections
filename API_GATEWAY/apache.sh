#!/bin/bash

# Install Apache
sudo apt update
sudo apt install apache2 -y

# Enable Apache modules
sudo a2enmod proxy
sudo a2enmod proxy_http

# Configure Apache as API gateway
sudo tee /etc/apache2/sites-available/api_gateway.conf > /dev/null <<EOT
<VirtualHost *:80>
    ServerName api.example.com

    ProxyPreserveHost On
    ProxyPass /api/ http://backend-api/
    ProxyPassReverse /api/ http://backend-api/
</VirtualHost>
EOT

sudo a2ensite api_gateway.conf

# Restart Apache to apply changes
sudo systemctl restart apache2
