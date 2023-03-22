#!/bin/bash

echo "Configuring Redis to allow external connections..."
echo ""

# Edit Redis configuration file to allow external connections
sudo sed -i "s/^bind 127.0.0.1/bind 0.0.0.0/" /etc/redis/redis.conf

# Restart Redis service
sudo systemctl restart redis.service

echo "Redis configured successfully to allow external connections!"
