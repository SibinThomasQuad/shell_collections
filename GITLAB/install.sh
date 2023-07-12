#!/bin/bash

# Update system packages
sudo apt-get update
sudo apt-get upgrade -y

# Install required dependencies
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Install GitLab
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo EXTERNAL_URL="http://your_server_hostname" apt-get install -y gitlab-ee

# Configure GitLab
sudo gitlab-ctl reconfigure

echo "GitLab installation and configuration completed!"
