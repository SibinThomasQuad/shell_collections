#!/bin/bash

# Install Monit
sudo apt-get update
sudo apt-get install monit -y

# Create Monit configuration file for Nginx
sudo touch /etc/monit/conf.d/nginx
sudo chmod 700 /etc/monit/conf.d/nginx

# Add Nginx monitoring configuration to Monit configuration file
sudo tee /etc/monit/conf.d/nginx << EOF
check process nginx with pidfile /run/nginx.pid
  start program = "/etc/init.d/nginx start"
  stop program = "/etc/init.d/nginx stop"
  if failed host 127.0.0.1 port 80 protocol http
    and request "/nginx_status" then restart
  if cpu usage > 95% for 10 cycles then alert
  if cpu usage > 99% for 5 cycles then restart
  if totalmem > 100.0 MB for 5 cycles then restart
  group nginx
EOF

# Restart Monit to apply changes
sudo service monit restart
