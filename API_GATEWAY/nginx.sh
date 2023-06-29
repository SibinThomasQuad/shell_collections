#!/bin/bash

# Install Nginx
sudo apt update
sudo apt install nginx -y

# Configure Nginx as API gateway
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-available/api_gateway.conf > /dev/null <<EOT
server {
    listen 80;
    server_name api.example.com;

    location /api/ {
        proxy_pass http://backend-api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOT

sudo ln -s /etc/nginx/sites-available/api_gateway.conf /etc/nginx/sites-enabled/api_gateway.conf

# Restart Nginx to apply changes
sudo systemctl restart nginx
