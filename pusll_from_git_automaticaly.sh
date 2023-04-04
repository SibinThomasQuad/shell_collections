#!/bin/bash

# Set the Git repository URL and directory
repo_url="https://github.com/username/repository.git"
repo_dir="/path/to/repository"

# Set the Git credentials (optional)
git_user="username"
git_password="password"

# Change to the repository directory
cd $repo_dir

# Pull from Git and check for changes
git pull

if [[ $(git status --porcelain) ]]; then
    # Changes detected, pull again and restart application
    git pull
    systemctl restart application.service
fi
