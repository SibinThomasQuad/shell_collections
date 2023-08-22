#!/bin/bash

# Detect the Linux distribution
distro=""
if [ -f /etc/os-release ]; then
    source /etc/os-release
    distro=$ID
fi

# Function to install Monit based on distribution
install_monit() {
    case $1 in
        debian|ubuntu)
            sudo apt-get update
            sudo apt-get install monit
            ;;
        centos|rhel|almalinux)  # Add 'almalinux' here
            sudo yum install epel-release
            sudo yum install monit
            ;;
        *)
            echo "Unsupported distribution: $1"
            exit 1
            ;;
    esac
}

# Check if Monit is installed
if ! command -v monit &> /dev/null; then
    read -p "Monit is not installed. Do you want to install it? (y/n): " install_monit_input
    if [[ "$install_monit_input" == "y" || "$install_monit_input" == "Y" ]]; then
        if [ -n "$distro" ]; then
            install_monit "$distro"
        else
            echo "Unable to determine distribution."
            exit 1
        fi
    else
        echo "Exiting..."
        exit 1
    fi
fi

# Options menu
PS3="Select an option: "
options=("Add Service to Monit" "Quit")
select opt in "${options[@]}"; do
    case $opt in
        "Add Service to Monit")
            read -p "Enter the service name: " service_name
            # Add the service to Monit configuration
            sudo tee "/etc/monit/conf-available/$service_name" > /dev/null <<EOF
check process $service_name with pidfile /run/$service_name.pid
    start program = "/etc/init.d/$service_name start"
    stop program = "/etc/init.d/$service_name stop"
EOF
            # Enable the Monit configuration file for the service
            sudo ln -s "/etc/monit/conf-available/$service_name" "/etc/monit/conf-enabled/"
            # Reload Monit to apply changes
            sudo monit reload
            echo "Service $service_name added to Monit."
            ;;
        "Quit")
            echo "Exiting..."
            break
            ;;
        *) echo "Invalid option";;
    esac
done
