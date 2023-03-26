#!/bin/bash

# Install Nginx
sudo apt-get update
sudo apt-get install nginx -y

# Backup default Nginx configuration
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Create new Nginx configuration file
sudo touch /etc/nginx/nginx.conf

# Add server configuration to Nginx configuration file
sudo tee /etc/nginx/nginx.conf << EOF
events {
    worker_connections  1024;
}

http {
    upstream backend {
        server 192.168.1.1:80;
        server 192.168.1.2:80;
        server 192.168.1.3:80;
    }

    server {
        listen 80;
        server_name example.com;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
}
EOF

# Restart Nginx to apply changes
sudo service nginx restart
