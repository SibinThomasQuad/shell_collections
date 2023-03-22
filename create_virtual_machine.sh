#!/bin/bash

# Define the VM name
VM_NAME="MyVirtualMachine"

# Define the OS type and version
OS_TYPE="Linux"
OS_VERSION="Ubuntu (64-bit)"

# Define the RAM size in MB
RAM_SIZE_MB=2048

# Define the virtual hard disk size in GB
HDD_SIZE_GB=20

# Define the ISO file path
ISO_FILE_PATH="/path/to/ubuntu-20.04.3-desktop-amd64.iso"

# Create the new virtual machine
VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register

# Configure the virtual machine
VBoxManage modifyvm "$VM_NAME" --memory "$RAM_SIZE_MB" --boot1 dvd --vrde on

# Create a new virtual hard disk
VBoxManage createhd --filename "$VM_NAME.vdi" --size "$HDD_SIZE_GB" --format VDI

# Attach the ISO file to the virtual machine
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_FILE_PATH"

# Attach the virtual hard disk to the virtual machine
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_NAME.vdi"

# Start the virtual machine
VBoxHeadless --startvm "$VM_NAME"

echo "The virtual machine '$VM_NAME' has been created and started."



<<com

This script uses the VBoxManage command to create a new virtual machine with the specified name, operating system type and version, RAM size, and virtual hard disk size. It then attaches an ISO file containing the operating system installation media to the virtual machine, and creates a new virtual hard disk for the virtual machine to use.

After configuring the virtual machine, the script starts the virtual machine using the VBoxHeadless command, which allows the virtual machine to run without a graphical user interface. The virtual machine will start in the background, and you can access it using a remote desktop connection or the VirtualBox GUI.

Note that this script assumes that you have already downloaded the ISO file for the operating system you want to install and that you have specified the path to the ISO file in the ISO_FILE_PATH variable. You will need to modify this variable to match the path to your ISO file.

<<com !"
