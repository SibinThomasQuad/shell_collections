#!/bin/bash

function view_repositories() {
    echo "List of currently added repositories:"
    grep -hE '^deb\s' /etc/apt/sources.list /etc/apt/sources.list.d/*
}

function add_repository() {
    read -p "Enter the repository to add (format: deb <repository_url> <distribution> <components>): " repo_line
    sudo add-apt-repository "$repo_line"
    sudo apt update
    echo "Repository added successfully."
}

function add_kali_repository() {
    echo "Adding Kali Linux repository..."
    echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" | sudo tee -a /etc/apt/sources.list.d/kali.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ED444FF07D8D0BF6
    sudo apt update
    echo "Kali Linux repository added successfully."
}

function add_php_repository() {
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt update
    echo "PHP repository added successfully."
}

function remove_repository() {
    view_repositories
    read -p "Enter the repository line to remove: " repo_line
    sudo sed -i "/$repo_line/d" /etc/apt/sources.list /etc/apt/sources.list.d/*
    sudo apt update
    echo "Repository removed successfully."
}

clear

echo "------------------------------------"
echo "      Repository Manager"
echo "------------------------------------"

while true; do
    echo "Select an option:"
    echo "1. View repositories"
    echo "2. Add repository"
    echo "3. Add Kali Linux repository"
    echo "4. Add PHP repository"
    echo "5. Remove repository"
    echo "6. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            view_repositories
            ;;
        2)
            add_repository
            ;;
        3)
            add_kali_repository
            ;;
        4)
            add_php_repository
            ;;
        5)
            remove_repository
            ;;
        6)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
