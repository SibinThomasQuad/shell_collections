#!/bin/bash

# Prompt user for their username
read -p "Enter username: " username

# Check if the user exists
if ! id -u "$username" >/dev/null 2>&1; then
  echo "User $username does not exist."
  exit 1
fi

# Prompt user to enter new password
read -s -p "Enter new password: " new_password
echo

# Change user password
echo "$username:$new_password" | chpasswd

echo "Password updated for user $username."


#---------------------  NOTE -------------------------------------------------------------------------------------

#This script first prompts the user to enter their username, and then checks if the user exists. If the user exists, #the script prompts the user to enter a new password (the -s flag hides the password as it is being typed), and then #changes the user's password using the chpasswd command. Finally, the script prints a message confirming that the #password has been updated.

#Note that this script should be run as root or with sudo privileges in order to be able to change user passwords.

#------------------------------------------------------------------------------------------------------------------
