#!/bin/bash

# Function to create a user
create_user() {
    read -p "Enter username: " username
    read -s -p "Enter password: " password
    echo
    echo "Creating user $username..."
    # Create the user with the specified username
    useradd $username
    # Set the user's password
    echo "$username:$password" | chpasswd
    echo "User $username created with password $password."
}

# Function to delete a user
delete_user() {
    read -p "Enter username: " username
    echo "Deleting user $username..."
    # Delete the user with the specified username
    userdel -r $username
    echo "User $username deleted."
}

# Function to change a user's password
change_password() {
    read -p "Enter username: " username
    read -s -p "Enter new password: " new_password
    echo
    echo "Changing password for user $username..."
    # Set the user's new password
    echo "$username:$new_password" | chpasswd
    echo "Password changed for user $username."
}

# Function to deactivate a user
deactivate_user() {
    read -p "Enter username: " username
    echo "Deactivating user $username..."
    # Lock the user's account
    passwd -l $username
    echo "User $username deactivated."
}

# Function to activate a user
activate_user() {
    read -p "Enter username: " username
    echo "Activating user $username..."
    # Unlock the user's account
    passwd -u $username
    echo "User $username activated."
}

# Display options menu
echo "User Management Script"
echo "----------------------"
echo "1. Create a user"
echo "2. Delete a user"
echo "3. Change a user's password"
echo "4. Deactivate a user"
echo "5. Activate a user"
echo

# Prompt for user input
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        create_user
        ;;
    2)
        delete_user
        ;;
    3)
        change_password
        ;;
    4)
        deactivate_user
        ;;
    5)
        activate_user
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
