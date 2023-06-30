#!/bin/bash

SERVICE_NAME="my-python-service"
PYTHON_EXECUTABLE="/usr/bin/python3"
PYTHON_FILE="/path/to/your/python/file.py"
PID_FILE="/var/run/my-python-service.pid"

start() {
    echo "Starting $SERVICE_NAME..."
    if [ -f $PID_FILE ]; then
        echo "$SERVICE_NAME is already running."
    else
        nohup $PYTHON_EXECUTABLE $PYTHON_FILE >/dev/null 2>&1 &
        echo $! > $PID_FILE
        echo "$SERVICE_NAME started."
    fi
}

stop() {
    echo "Stopping $SERVICE_NAME..."
    if [ -f $PID_FILE ]; then
        kill $(cat $PID_FILE)
        rm $PID_FILE
        echo "$SERVICE_NAME stopped."
    else
        echo "$SERVICE_NAME is not running."
    fi
}

status() {
    if [ -f $PID_FILE ]; then
        echo "$SERVICE_NAME is running. (PID: $(cat $PID_FILE))"
    else
        echo "$SERVICE_NAME is not running."
    fi
}

restart() {
    stop
    start
}

show_menu() {
    PS3="Select an option: "
    options=("Start" "Stop" "Restart" "Status" "Quit")
    select opt in "${options[@]}";
    do
        case $opt in
            "Start")
                start
                ;;
            "Stop")
                stop
                ;;
            "Restart")
                restart
                ;;
            "Status")
                status
                ;;
            "Quit")
                break
                ;;
            *)
                echo "Invalid option. Try again."
                ;;
        esac
    done
}

show_menu

exit 0
