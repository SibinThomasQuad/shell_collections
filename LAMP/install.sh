#!/bin/bash

# Update package repositories
apt update

# Install Apache
apt install apache2 -y

# Enable required Apache modules
a2enmod proxy_fcgi setenvif rewrite headers

# Install PHP-FPM and multiple PHP versions
apt install php7.4-fpm php7.4 php7.4-cli -y
apt install php8.0-fpm php8.0 php8.0-cli -y

# Configure PHP-FPM pools for multiple PHP versions
cat <<EOF > /etc/php/7.4/fpm/pool.d/php74.conf
[php74]
user = www-data
group = www-data
listen = /run/php/php7.4-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[upload_max_filesize] = 32M
php_admin_value[post_max_size] = 32M
php_admin_value[memory_limit] = 256M
EOF

cat <<EOF > /etc/php/8.0/fpm/pool.d/php80.conf
[php80]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[upload_max_filesize] = 32M
php_admin_value[post_max_size] = 32M
php_admin_value[memory_limit] = 256M
EOF

# Restart PHP-FPM
systemctl restart php7.4-fpm
systemctl restart php8.0-fpm

# Install MySQL
apt install mysql-server -y

# Secure MySQL installation (optional)
mysql_secure_installation

# Install phpMyAdmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Configure phpMyAdmin Apache integration
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

# Restart Apache
systemctl restart apache2

# Install FTP server (vsftpd)
apt install vsftpd -y

# Configure FTP server (optional)
# Modify /etc/vsftpd.conf to suit your needs

# Restart FTP server
systemctl restart vsftpd

# Install SSH server (openssh-server)
apt install openssh-server -y

# Configure SSH server (optional)
# Modify /etc/ssh/sshd_config to suit your needs

# Restart SSH server
systemctl restart ssh

# Install and configure Apache ModSecurity
apt install libapache2-mod-security2 -y

# Enable ModSecurity
ln -s /usr/share/modsecurity-crs/activated_rules/ /etc/apache2/conf-available/

# Enable ModSecurity in Apache
a2enmod security2

# Restart Apache
systemctl restart apache2

# Clean up
apt autoremove -y
