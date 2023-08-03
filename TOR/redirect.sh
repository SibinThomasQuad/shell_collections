#!/bin/bash

# Check if the script is executed with root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Define the network interface to redirect traffic through Tor
TOR_IFACE="tor0"

start_tor_redirection() {
  # Stop Tor if it's already running to avoid conflicts
  service tor stop

  # ... (rest of the function remains unchanged)

  echo "All traffic is now redirected via Tor."
}

stop_tor_redirection() {
  # ... (function remains unchanged)

  echo "Tor redirection has been stopped. All outgoing traffic is allowed."
}

restart_tor_redirection() {
  stop_tor_redirection
  start_tor_redirection
}

print_menu() {
  echo "Choose an option:"
  echo "1. Start Tor redirection"
  echo "2. Stop Tor redirection"
  echo "3. Restart Tor redirection"
  echo "4. Exit"
}

if [ $EUID -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

while true; do
  print_menu
  read -p "Enter your choice (1-4): " choice

  case "$choice" in
    1)
      start_tor_redirection
      ;;
    2)
      stop_tor_redirection
      ;;
    3)
      restart_tor_redirection
      ;;
    4)
      exit 0
      ;;
    *)
      echo "Invalid choice. Please select a valid option (1-4)."
      ;;
  esac

  echo
done
