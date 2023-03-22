#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev build-essential libssl-dev libffi-dev nginx

# Create a virtual environment for the project
sudo pip3 install virtualenv
virtualenv -p python3 myprojectenv
source myprojectenv/bin/activate

# Install Django and other required packages
pip3 install django gunicorn psycopg2-binary

# Configure Nginx
sudo rm /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/myproject
sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled/
sudo echo "
server {
    listen 80;
    server_name myproject.com;
    access_log off;

    location /static/ {
        alias /path/to/static/files/;
    }

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}" > /etc/nginx/sites-available/myproject

sudo systemctl restart nginx

# Deploy Django project
cd /path/to/django/project
python3 manage.py collectstatic --noinput
python3 manage.py migrate
gunicorn myproject.wsgi:application --bind 127.0.0.1:8000 --daemon

echo "Django project deployed with Nginx."

#--------------------------------------- NOTE ------------------------------------------------------------------

#This script performs the following actions:

#   Installs required packages, including Python, pip, Nginx, and other dependencies.

#    Creates a virtual environment for the project and installs Django and other required packages.

#   Configures N

#---------------------------------------------------------------------------------------------------------------
