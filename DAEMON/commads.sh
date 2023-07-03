#!/bin/bash

# Define an array to hold the commands
declare -a commands=("command1" "command2" "command3")

# Function to start the commands
start_commands() {
    for command in "${commands[@]}"; do
        # Run the command in the background
        $command &
        # Save the PID (Process ID) of each command
        pid=$!
        echo "Command '$command' started with PID $pid"
        # Store the PID in a file for later reference
        echo $pid >> pids.txt
    done
}

# Function to stop all commands
stop_commands() {
    # Read the PIDs from the file
    while IFS= read -r pid; do
        # Check if the process is still running
        if ps -p $pid > /dev/null; then
            # Kill the process
            kill $pid
            echo "Process with PID $pid stopped"
        else
            echo "Process with PID $pid is already stopped"
        fi
    done < pids.txt
    # Remove the PID file
    rm pids.txt
}

# Function to restart all commands
restart_commands() {
    stop_commands
    start_commands
}

# Function to add a new command
add_command() {
    echo "Enter the new command:"
    read new_command
    commands+=("$new_command")
    echo "New command added: $new_command"
}

# Function to show running commands
show_running_commands() {
    echo "Running commands:"
    for pid in $(cat pids.txt); do
        if ps -p $pid > /dev/null; then
            command=$(ps -p $pid -o command=)
            echo "PID $pid: $command"
        fi
    done
}

# Main program loop
while true; do
    echo "Select an option:"
    echo "1. Start commands"
    echo "2. Stop commands"
    echo "3. Restart commands"
    echo "4. Add a new command"
    echo "5. Show running commands"
    echo "6. Exit"

    read option

    case $option in
        1)
            start_commands
            ;;
        2)
            stop_commands
            ;;
        3)
            restart_commands
            ;;
        4)
            add_command
            ;;
        5)
            show_running_commands
            ;;
        6)
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
