#!/bin/bash

echo "Enter the domain name for the server block (e.g. example.com):"
read domain

echo "Enter the path to the website root directory (e.g. /var/www/example.com):"
read directory

# create the server block configuration file
cat > /etc/nginx/sites-available/$domain <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name $domain;

    root $directory;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# enable the server block
ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/

# test Nginx configuration and reload Nginx
nginx -t && systemctl reload nginx

echo "Domain name mapped successfully!"
