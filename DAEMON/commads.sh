#!/bin/bash

# Define an associative array to hold the commands and their logs
declare -A commands

# Function to start a command
start_command() {
    local command=$1
    # Run the command in the background and redirect output to a log file with the current date
    local log_file="${command}_log_$(date +'%Y-%m-%d').txt"
    $command >> "$log_file" 2>&1 &
    # Save the PID (Process ID) of the command
    pid=$!
    # Store the PID and log file in the associative array
    commands[$command]=$pid
    commands["${command}_log"]=$log_file
    echo "Command '$command' started with PID $pid"
}

# Function to stop a command
stop_command() {
    local command=$1
    # Check if the command is running
    if [ ${commands[$command]+_} ] && ps -p ${commands[$command]} > /dev/null; then
        # Kill the command process
        kill ${commands[$command]}
        echo "Command '$command' stopped"
        # Remove the PID and log file entries from the associative array
        unset commands[$command]
        unset commands["${command}_log"]
    else
        echo "Command '$command' is not running"
    fi
}

# Function to restart a command
restart_command() {
    local command=$1
    stop_command $command
    start_command $command
}

# Function to add a new command
add_command() {
    echo "Enter the new command:"
    read new_command
    # Check if the command already exists
    if [ ${commands[$new_command]+_} ]; then
        echo "Command '$new_command' already exists"
    else
        commands[$new_command]=""
        echo "New command added: $new_command"
    fi
}

# Function to remove a command
remove_command() {
    echo "Enter the command to remove:"
    read remove_command
    # Check if the command exists
    if [ ${commands[$remove_command]+_} ]; then
        stop_command $remove_command
        # Remove the command from the associative array
        unset commands[$remove_command]
        unset commands["${remove_command}_log"]
        echo "Command '$remove_command' removed"
    else
        echo "Command '$remove_command' does not exist"
    fi
}

# Function to show running commands
show_running_commands() {
    echo "Running commands:"
    for command in "${!commands[@]}"; do
        pid=${commands[$command]}
        if ps -p $pid > /dev/null; then
            echo "PID $pid: $command"
        fi
    done
}

# Main program loop
while true; do
    echo "Select an option:"
    echo "1. Start command"
    echo "2. Stop command"
    echo "3. Restart command"
    echo "4. Add a new command"
    echo "5. Remove a command"
    echo "6. Show running commands"
    echo "7. Exit"

    read option

    case $option in
        1)
            echo "Enter the command to start:"
            read start_command
            start_command "$start_command"
            ;;
        2)
            echo "Enter the command to stop:"
            read stop_command
            stop_command "$stop_command"
            ;;
        3)
            echo "Enter the command to restart:"
            read restart_command
            restart_command "$restart_command"
            ;;
        4)
            add_command
            ;;
        5)
            remove_command
            ;;
        6)
            show_running_commands
            ;;
        7)
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
