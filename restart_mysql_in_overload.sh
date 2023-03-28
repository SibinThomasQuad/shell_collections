#!/bin/bash

# Set the load threshold (change this as needed)
load_threshold=5

while true
do
    # Get the 1-minute load average
    load=$(uptime | awk '{print $10}' | sed 's/,//')

    # Check if the load average exceeds the threshold
    if [ $(echo "$load > $load_threshold" | bc -l) -eq 1 ]
    then
        # Restart the MySQL service
        systemctl restart mysql
        echo "$(date): MySQL restarted due to high load (load average: $load)"
    fi

    # Wait for 1 minute before checking the load again
    sleep 60
done
