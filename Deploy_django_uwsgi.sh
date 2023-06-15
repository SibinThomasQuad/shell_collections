#!/bin/bash

# Variables
APP_NAME="myapp"  # Replace with your Django app name
APP_PATH="/path/to/your/app"  # Replace with the path to your Django app
VENV_NAME="myenv"  # Replace with your virtual environment name
UWSGI_SOCKET="127.0.0.1:8000"  # Replace with the desired socket address
UWSGI_PROCESSES=4  # Replace with the desired number of uWSGI worker processes
NGINX_CONFIG="/etc/nginx/sites-available/myapp"  # Replace with your Nginx config file path
NGINX_ENABLED="/etc/nginx/sites-enabled/"  # Replace with the directory for enabled Nginx sites

# Activate the virtual environment
source $APP_PATH/$VENV_NAME/bin/activate

# Change to the app directory
cd $APP_PATH

# Install/update dependencies
pip install -r requirements.txt

# Collect static files
python manage.py collectstatic --noinput

# Run database migrations
python manage.py migrate

# Start uWSGI
uwsgi --socket $UWSGI_SOCKET \
       --wsgi-file $APP_NAME/wsgi.py \
       --processes $UWSGI_PROCESSES \
       --master \
       --enable-threads \
       --chdir $APP_PATH \
       --daemonize $APP_PATH/uwsgi.log

# Configure Nginx
echo "server {
    listen 80;
    server_name yourdomain.com;  # Replace with your domain name

    location / {
        uwsgi_pass $UWSGI_SOCKET;
        include /etc/nginx/uwsgi_params;
    }

    location /static/ {
        alias $APP_PATH/static/;
    }
}" | tee $NGINX_CONFIG

# Enable the Nginx site
ln -s $NGINX_CONFIG $NGINX_ENABLED

# Restart Nginx
service nginx restart
