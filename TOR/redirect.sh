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

  # Flush existing iptables rules
  iptables -F
  iptables -t nat -F

  # Set the default policies to DROP
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  # Allow loopback traffic
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  # Allow established and related connections
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Allow Tor traffic on the Tor interface
  iptables -A OUTPUT -o $TOR_IFACE -j ACCEPT

  # Redirect all outgoing traffic to Tor
  iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040

  # Allow DNS queries through Tor
  iptables -t nat -A PREROUTING -i $TOR_IFACE -p udp --dport 53 -j REDIRECT --to-ports 53

  # Allow DNS resolution for Tor (optional, in case your system uses a local resolver)
  iptables -A OUTPUT -d 127.0.0.1 -p udp --dport 53 -j ACCEPT

  # Allow outgoing traffic on the Tor interface
  iptables -A OUTPUT -o $TOR_IFACE -j ACCEPT

  # Reject all other outgoing traffic (to prevent leakage)
  iptables -A OUTPUT -j REJECT

  # Save the iptables rules
  iptables-save > /etc/iptables/rules.v4

  # Start Tor
  service tor start

  echo "All traffic is now redirected via Tor."
}

stop_tor_redirection() {
  # Flush existing iptables rules
  iptables -F
  iptables -t nat -F

  # Set the default policies to ACCEPT
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT

  # Save the iptables rules
  iptables-save > /etc/iptables/rules.v4

  # Stop Tor
  service tor stop

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
