#!/bin/bash

# Download and extract phpMyAdmin
sudo apt update
sudo apt install wget unzip -y
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip
unzip phpMyAdmin-5.1.1-all-languages.zip
sudo mv phpMyAdmin-5.1.1-all-languages /var/www/html/phpmyadmin

# Configure phpMyAdmin
sudo cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
sudo sed -i "s/localhost/127.0.0.1/" /var/www/html/phpmyadmin/config.inc.php

# Set up a blowfish secret passphrase
blowfish_secret=$(openssl rand -base64 32)
sudo sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg['blowfish_secret'] = '${blowfish_secret}';/" /var/www/html/phpmyadmin/config.inc.php

# Set ownership and permissions
sudo chown -R www-data:www-data /var/www/html/phpmyadmin
sudo chmod -R 755 /var/www/html/phpmyadmin
