#!/bin/bash

# Install HAProxy
sudo apt update
sudo apt install haproxy -y

# Configure HAProxy as API gateway
sudo tee /etc/haproxy/haproxy.cfg > /dev/null <<EOT
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    acl api_path path_beg /api/
    use_backend backend-api if api_path

backend backend-api
    server backend-server1 192.168.0.101:8080 check
    server backend-server2 192.168.0.102:8080 check
EOT

# Restart HAProxy to apply changes
sudo systemctl restart haproxy
