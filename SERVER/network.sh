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

view_blacklisted_ips() {
  echo "Blacklisted IP Addresses:"
  iptables-save | grep "OUTPUT -d" | awk '{print $NF}' | sort -u
}

view_whitelisted_ips() {
  echo "Whitelisted IP Addresses:"
  iptables-save | grep "INPUT -s" | awk '{print $NF}' | sort -u
}

show_private_ip() {
  private_ip=$(ip route get 1.1.1.1 | awk '{print $7}')
  echo "Your private IP address is: $private_ip"
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

show_public_ip() {
  public_ip=$(curl -s ifconfig.co)
  echo "Your public IP address is: $public_ip"
}

show_router_gateway_details() {
  echo "Router and Gateway Details:"
  ip route show | grep "default via"
}

show_most_visited_ips() {
  echo "Most Visited IP Addresses:"
  ss -tuln | awk 'NR > 1 {print $5}' | cut -d':' -f1 | sort | uniq -c | sort -nr
}

view_apache_logs_in_date_range() {
  echo "Enter the start date (format: YYYY-MM-DD):"
  read -p "> " start_date
  echo "Enter the end date (format: YYYY-MM-DD):"
  read -p "> " end_date

  if [[ ! -f /var/log/apache2/access.log ]]; then
    echo "Apache log file not found: /var/log/apache2/access.log"
    return
  fi

  echo "Apache log IP addresses and URLs between $start_date and $end_date:"
  awk -v start="$start_date" -v end="$end_date" '$4 >= start && $4 <= end {print $1, $7}' /var/log/apache2/access.log
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
  echo "9. View blacklisted IP addresses"
  echo "10. View whitelisted IP addresses"
  echo "11. Show all open ports"
  echo "12. Show applications using each port"
  echo "13. Show live connections"
  echo "14. Show your public IP address"
  echo "15. Show your private IP address"
  echo "16. Show router and gateway details"
  echo "17. Show most visited IP addresses and their counts"
  echo "18. View Apache log IP addresses and URLs in a date range"
  echo "19. Exit"
}

while true; do
  print_menu
  read -p "Enter your choice (1-19): " choice

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
      view_blacklisted_ips
      ;;
    10)
      view_whitelisted_ips
      ;;
    11)
      show_all_ports
      ;;
    12)
      show_applications_using_ports
      ;;
    13)
      show_live_connections
      ;;
    14)
      show_public_ip
      ;;
    15)
      show_private_ip
      ;;
    16)
      show_router_gateway_details
      ;;
    17)
      show_most_visited_ips
      ;;
    18)
      view_apache_logs_in_date_range
      ;;
    19)
      exit 0
      ;;
    *)
      echo "Invalid choice. Please select a valid option (1-19)."
      ;;
  esac

  echo
done
