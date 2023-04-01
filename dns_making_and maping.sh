#!/bin/bash

# Install BIND
sudo apt-get update
sudo apt-get install bind9

# Create DNS zone file
sudo nano /etc/bind/db.example.com

# Add the following contents to the file
$TTL    604800
@       IN      SOA     ns1.example.com. admin.example.com. (
                  1         ; Serial
             604800         ; Refresh
              86400         ; Retry
            2419200         ; Expire
             604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.example.com.
@       IN      A       192.168.1.2
www     IN      CNAME   server.example.com.

# Save and close the file

# Configure BIND
sudo nano /etc/bind/named.conf.local

# Add the following contents to the file
zone "example.com" {
    type master;
    file "/etc/bind/db.example.com";
};

# Save and close the file

# Restart BIND
sudo systemctl restart bind9

# Map domain to another server
sudo nano /etc/hosts

# Add the following line to the file
192.168.1.3 server.example.com

# Save and close the file
