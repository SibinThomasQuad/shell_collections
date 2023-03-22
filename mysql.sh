#!/bin/bash

# Update package manager
sudo apt-get update

# Install MySQL Server
sudo apt-get install mysql-server

# Configure MySQL Server
sudo mysql_secure_installation

