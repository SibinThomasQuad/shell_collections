#!/bin/bash

# Install Nginx and PHP
sudo apt-get update
sudo apt-get install nginx php-fpm php-mysql -y

# Create new Nginx configuration file for PHP project
sudo touch /etc/nginx/sites-available/myproject.conf

# Add server configuration to Nginx configuration file
sudo tee /etc/nginx/sites-available/myproject.conf << EOF
server {
    listen 80;
    listen [::]:80;
    server_name myproject.com;
    root /var/www/myproject;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Create project directory and move project files to it
sudo mkdir /var/www/myproject
sudo mv /path/to/myproject/* /var/www/myproject

# Set ownership and permissions for project directory
sudo chown -R www-data:www-data /var/www/myproject
sudo chmod -R 755 /var/www/myproject

# Enable Nginx configuration file for PHP project
sudo ln -s /etc/nginx/sites-available/myproject.conf /etc/nginx/sites-enabled/

# Restart Nginx to apply changes
sudo service nginx restart
