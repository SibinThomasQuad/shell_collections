#!/bin/bash

echo "Enter the domain name for the virtual host (e.g. example.com):"
read domain

echo "Enter the path to the website root directory (e.g. /var/www/example.com):"
read directory

# create the virtual host configuration file
cat > /etc/apache2/sites-available/$domain.conf <<EOF
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $directory

    <Directory $directory>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/$domain.error.log
    CustomLog ${APACHE_LOG_DIR}/$domain.access.log combined
</VirtualHost>
EOF

# enable the virtual host
a2ensite $domain.conf

# reload Apache configuration
systemctl reload apache2

echo "Virtual host created successfully!"
