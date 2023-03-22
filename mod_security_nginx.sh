#!/bin/bash

# Install mod_security and its dependencies
sudo apt-get update
sudo apt-get install -y libnginx-mod-http-modsecurity

# Enable mod_security
sudo sed -i 's/#include \/etc\/nginx\/modules-enabled\/\*.conf;/include \/etc\/nginx\/modules-enabled\/\*.conf;/' /etc/nginx/nginx.conf
sudo ln -s /usr/share/modsecurity-crs /etc/nginx/modsecurity-crs
sudo sed -i 's/modsecurity_rules_file .*;/modsecurity_rules_file \/etc\/nginx\/modsecurity-crs\/modsecurity.conf;/' /etc/nginx/mods-available/mod-security.conf

# Configure mod_security
sudo touch /etc/nginx/modsecurity-rules.conf
sudo cat > /etc/nginx/modsecurity-rules.conf <<EOF
SecRuleEngine On
SecRequestBodyAccess On
EOF

# Configure Nginx to use mod_security
sudo ln -s /etc/nginx/mods-available/mod-security.conf /etc/nginx/modules-enabled/50-mod-security.conf

# Restart Nginx to apply changes
sudo systemctl restart nginx
