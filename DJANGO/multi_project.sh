#!/bin/bash

PROJECT1_PATH="/path/to/project1"
PROJECT2_PATH="/path/to/project2"

start_project() {
    local project_path=$1
    echo "Starting the Django project at $project_path..."
    # Activate the virtual environment if needed
    # Example: source /path/to/venv/bin/activate
    # Start the Django development server
    (cd "$project_path" && python manage.py runserver)
}

stop_project() {
    local project_path=$1
    echo "Stopping the Django project at $project_path..."
    # Find the process ID of the Django development server and terminate it
    pid=$(ps aux | grep "python manage.py runserver" | grep "$project_path" | awk '{print $2}')
    if [ -n "$pid" ]; then
        kill "$pid"
    fi
}

restart_project() {
    local project_path=$1
    stop_project "$project_path"
    sleep 1
    start_project "$project_path"
}

case "$1" in
    start)
        case "$2" in
            1)
                start_project "$PROJECT1_PATH"
                ;;
            2)
                start_project "$PROJECT2_PATH"
                ;;
            *)
                echo "Invalid project ID"
                exit 1
                ;;
        esac
        ;;
    stop)
        case "$2" in
            1)
                stop_project "$PROJECT1_PATH"
                ;;
            2)
                stop_project "$PROJECT2_PATH"
                ;;
            *)
                echo "Invalid project ID"
                exit 1
                ;;
        esac
        ;;
    restart)
        case "$2" in
            1)
                restart_project "$PROJECT1_PATH"
                ;;
            2)
                restart_project "$PROJECT2_PATH"
                ;;
            *)
                echo "Invalid project ID"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 {start|stop|restart} <project_id>"
        exit 1
        ;;
esac

exit 0
