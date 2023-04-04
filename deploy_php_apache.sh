#!/bin/bash

# Install Apache web server and mod_wsgi
sudo apt update
sudo apt install apache2 libapache2-mod-wsgi-py3

# Install required packages for the Django app
sudo apt install python3 python3-pip python3-venv
sudo apt install libpq-dev python3-dev

# Create a virtual environment for the Django app
cd /var/www
sudo mkdir myproject
cd myproject
sudo python3 -m venv myenv
sudo chown -R $USER:$USER /var/www/myproject
source myenv/bin/activate

# Install Django and other required packages
pip install django
pip install psycopg2

# Create a new Django project
django-admin startproject myproject .

# Create a new Apache configuration file for the Django app
sudo touch /etc/apache2/sites-available/myproject.conf
sudo chmod 777 /etc/apache2/sites-available/myproject.conf

# Edit the Apache configuration file
sudo echo "<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    DocumentRoot /var/www/myproject
    Alias /static /var/www/myproject/static
    <Directory /var/www/myproject/static>
        Require all granted
    </Directory>
    <Directory /var/www/myproject/myproject>
        <Files wsgi.py>
            Require all granted
        </Files>
    </Directory>
    WSGIDaemonProcess myproject python-home=/var/www/myproject/myenv python-path=/var/www/myproject
    WSGIProcessGroup myproject
    WSGIScriptAlias / /var/www/myproject/myproject/wsgi.py
</VirtualHost>" > /etc/apache2/sites-available/myproject.conf

# Enable the Apache configuration file and restart Apache
sudo a2ensite myproject.conf
sudo systemctl restart apache2

# Create a new Django app within the Django project
cd /var/www/myproject
python manage.py startapp myapp
