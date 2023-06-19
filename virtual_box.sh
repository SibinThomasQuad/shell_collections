#!/bin/bash

# Function to start a virtual machine
start_vm() {
    vm_name=$1
    vboxmanage startvm "$vm_name" --type headless
    echo "Virtual machine $vm_name started."
}

# Function to stop a virtual machine
stop_vm() {
    vm_name=$1
    vboxmanage controlvm "$vm_name" poweroff
    echo "Virtual machine $vm_name stopped."
}

# Function to list all virtual machines
list_vms() {
    vboxmanage list vms
}

# Function to delete a virtual machine
delete_vm() {
    vm_name=$1
    vboxmanage unregistervm "$vm_name" --delete
    echo "Virtual machine $vm_name deleted."
}

# Main menu
while true; do
    echo "1. Start a virtual machine"
    echo "2. Stop a virtual machine"
    echo "3. List all virtual machines"
    echo "4. Delete a virtual machine"
    echo "5. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter the name of the virtual machine to start: " vm_name
            start_vm "$vm_name"
            ;;
        2)
            read -p "Enter the name of the virtual machine to stop: " vm_name
            stop_vm "$vm_name"
            ;;
        3)
            list_vms
            ;;
        4)
            read -p "Enter the name of the virtual machine to delete: " vm_name
            delete_vm "$vm_name"
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    echo
done
