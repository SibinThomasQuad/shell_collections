#!/bin/bash

# Install HAProxy
sudo apt-get update
sudo apt-get install haproxy -y

# Backup default HAProxy configuration
sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak

# Create new HAProxy configuration file
sudo touch /etc/haproxy/haproxy.cfg

# Add server configuration to HAProxy configuration file
sudo tee /etc/haproxy/haproxy.cfg << EOF
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000
    timeout client 50000
    timeout server 50000

frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    server server1 192.168.1.1:80 check
    server server2 192.168.1.2:80 check
    server server3 192.168.1.3:80 check
EOF

# Restart HAProxy to apply changes
sudo service haproxy restart
