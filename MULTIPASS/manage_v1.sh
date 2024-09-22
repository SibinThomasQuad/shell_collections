#!/bin/bash

# Function to install Multipass
install_multipass() {
    echo "Installing Multipass..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo snap install multipass
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask multipass
    else
        echo "Unsupported OS. Please install Multipass manually."
        exit 1
    fi
}

# Function to create a new VM
create_vm() {
    read -p "Enter VM name: " VM_NAME
    read -p "Enter storage size (e.g., 10G, 20G): " STORAGE_SIZE

    echo "Creating VM with name: $VM_NAME and storage: $STORAGE_SIZE..."
    multipass launch -n "$VM_NAME" --disk "$STORAGE_SIZE"

    if [ $? -eq 0 ]; then
        echo "VM '$VM_NAME' created successfully with $STORAGE_SIZE storage."
    else
        echo "Failed to create VM '$VM_NAME'. Please check the inputs and try again."
    fi
}

# Function to start a VM
start_vm() {
    read -p "Enter the VM name to start: " VM_NAME

    echo "Starting VM '$VM_NAME'..."
    multipass start "$VM_NAME"

    if [ $? -eq 0 ]; then
        echo "VM '$VM_NAME' started successfully."
    else
        echo "Failed to start VM '$VM_NAME'. Please check the name and try again."
    fi
}

# Function to stop a VM
stop_vm() {
    read -p "Enter the VM name to stop: " VM_NAME

    echo "Stopping VM '$VM_NAME'..."
    multipass stop "$VM_NAME"

    if [ $? -eq 0 ]; then
        echo "VM '$VM_NAME' stopped successfully."
    else
        echo "Failed to stop VM '$VM_NAME'. Please check the name and try again."
    fi
}

# Main menu
while true; do
    echo ""
    echo "====== Multipass Menu ======"
    echo "1. Install Multipass"
    echo "2. Create a VM"
    echo "3. Start a VM"
    echo "4. Stop a VM"
    echo "5. Exit"
    echo "============================"
    read -p "Choose an option [1-5]: " choice

    case $choice in
        1)
            if ! command -v multipass &> /dev/null; then
                echo "Multipass is not installed. Installing now..."
                install_multipass
            else
                echo "Multipass is already installed."
            fi
            ;;
        2)
            if command -v multipass &> /dev/null; then
                create_vm
            else
                echo "Multipass is not installed. Please install it first."
            fi
            ;;
        3)
            if command -v multipass &> /dev/null; then
                start_vm
            else
                echo "Multipass is not installed. Please install it first."
            fi
            ;;
        4)
            if command -v multipass &> /dev/null; then
                stop_vm
            else
                echo "Multipass is not installed. Please install it first."
            fi
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please select a valid option."
            ;;
    esac
done
