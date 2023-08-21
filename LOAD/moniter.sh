#!/bin/bash

# Function to display system information
show_system_info() {
    echo "System Information:"
    echo "===================="
    uname -a
    echo ""
    uptime
    echo ""
}

# Function to display CPU usage
show_cpu_usage() {
    echo "CPU Usage:"
    echo "=========="
    top -n 1 -b
    echo ""
}

# Function to display memory usage
show_memory_usage() {
    echo "Memory Usage:"
    echo "============="
    free -h
    echo ""
}

# Function to display disk usage
show_disk_usage() {
    echo "Disk Usage:"
    echo "==========="
    df -h
    echo ""
}

# Function to display network usage
show_network_usage() {
    echo "Network Usage:"
    echo "=============="
    ifconfig
    echo ""
}

# Main menu loop
while true; do
    clear
    echo "Resource Load Details"
    echo "======================"
    echo "1. System Information"
    echo "2. CPU Usage"
    echo "3. Memory Usage"
    echo "4. Disk Usage"
    echo "5. Network Usage"
    echo "6. Exit"
    read -p "Select an option: " choice

    case $choice in
        1)
            show_system_info
            ;;
        2)
            show_cpu_usage
            ;;
        3)
            show_memory_usage
            ;;
        4)
            show_disk_usage
            ;;
        5)
            show_network_usage
            ;;
        6)
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac

    read -p "Press Enter to continue..."
done
