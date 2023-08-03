#!/bin/bash

# Check if the script is executed with root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

block_all_traffic() {
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP
  echo "All traffic is now blocked."
}

release_all_traffic() {
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT
  echo "All traffic is now allowed."
}

block_outgoing_ip() {
  read -p "Enter the IP address to block outgoing traffic: " ip
  iptables -A OUTPUT -d $ip -j DROP
  echo "Outgoing traffic to $ip is blocked."
}

unblock_outgoing_ip() {
  read -p "Enter the IP address to unblock outgoing traffic: " ip
  iptables -D OUTPUT -d $ip -j DROP
  echo "Outgoing traffic to $ip is unblocked."
}

open_port() {
  read -p "Enter the port number to open: " port
  iptables -A INPUT -p tcp --dport $port -j ACCEPT
  echo "Port $port is now open."
}

close_port() {
  read -p "Enter the port number to close: " port
  iptables -D INPUT -p tcp --dport $port -j ACCEPT
  echo "Port $port is now closed."
}

create_white_list() {
  echo "Enter IP addresses to whitelist (separated by spaces):"
  read -p "> " ips
  for ip in $ips; do
    iptables -A INPUT -s $ip -j ACCEPT
  done
  echo "IP addresses whitelisted: $ips"
}

create_black_list() {
  echo "Enter IP addresses to blacklist (separated by spaces):"
  read -p "> " ips
  for ip in $ips; do
    iptables -A INPUT -s $ip -j DROP
  done
  echo "IP addresses blacklisted: $ips"
}

show_all_ports() {
  netstat -tuln
}

show_applications_using_ports() {
  lsof -i -P -n
}

show_live_connections() {
  ss -tulwn
}

print_menu() {
  echo "Choose an option:"
  echo "1. Block all traffic"
  echo "2. Release all traffic"
  echo "3. Block outgoing traffic to a specific IP"
  echo "4. Unblock outgoing traffic to a specific IP"
  echo "5. Open a port"
  echo "6. Close a port"
  echo "7. Create a white list of IP addresses"
  echo "8. Create a black list of IP addresses"
  echo "9. Show all open ports"
  echo "10. Show applications using each port"
  echo "11. Show live connections"
  echo "12. Exit"
}

while true; do
  print_menu
  read -p "Enter your choice (1-12): " choice

  case "$choice" in
    1)
      block_all_traffic
      ;;
    2)
      release_all_traffic
      ;;
    3)
      block_outgoing_ip
      ;;
    4)
      unblock_outgoing_ip
      ;;
    5)
      open_port
      ;;
    6)
      close_port
      ;;
    7)
      create_white_list
      ;;
    8)
      create_black_list
      ;;
    9)
      show_all_ports
      ;;
    10)
      show_applications_using_ports
      ;;
    11)
      show_live_connections
      ;;
    12)
      exit 0
      ;;
    *)
      echo "Invalid choice. Please select a valid option (1-12)."
      ;;
  esac

  echo
done
