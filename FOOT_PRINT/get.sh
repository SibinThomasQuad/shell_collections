#!/bin/bash

# Function to view activities in system log
view_system_log() {
  echo "System log activities between $start_date and $end_date:"
  grep -E "^$start_date|$end_date" /var/log/syslog
}

# Function to view activities in auth log
view_auth_log() {
  echo "Auth log activities between $start_date and $end_date:"
  grep -E "^$start_date|$end_date" /var/log/auth.log
}

# Function to view bash history activities for a user
view_bash_history() {
  local user="$1"
  echo "Bash history activities for user $user between $start_date and $end_date:"
  grep -E "^#\\s+$start_date|$end_date" "/home/$user/.bash_history"
}

# Function to view installed applications
view_installed_apps() {
  echo "Installed applications:"
  if [ -x "$(command -v dpkg)" ]; then
    dpkg -l
  elif [ -x "$(command -v rpm)" ]; then
    rpm -qa
  else
    echo "Package manager not found. Unable to list installed applications."
  fi
}

print_menu() {
  echo "Choose an option:"
  echo "1. View activities in the system log"
  echo "2. View activities in the auth log"
  echo "3. View bash history activities for all users"
  echo "4. View installed applications"
  echo "5. Exit"
}

# Get start and end date from user
echo "Enter the start date (format: YYYY-MM-DD):"
read -p "> " start_date
echo "Enter the end date (format: YYYY-MM-DD):"
read -p "> " end_date

while true; do
  print_menu
  read -p "Enter your choice (1-5): " choice

  case "$choice" in
    1)
      view_system_log
      ;;
    2)
      view_auth_log
      ;;
    3)
      for user in /home/*; do
        if [ -d "$user" ]; then
          user=$(basename "$user")
          view_bash_history "$user"
        fi
      done
      ;;
    4)
      view_installed_apps
      ;;
    5)
      exit 0
      ;;
    *)
      echo "Invalid choice. Please select a valid option (1-5)."
      ;;
  esac

  echo
done
