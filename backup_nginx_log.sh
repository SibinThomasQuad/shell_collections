#!/bin/bash

# Define the log file path
LOGFILE=/var/log/nginx/access.log

# Define the backup directory
BACKUP_DIR=/var/log/nginx/backups

# Create the backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

# Define the backup filename with date stamp
BACKUP_FILE="$BACKUP_DIR/access-$(date +%Y-%m-%d).log"

# Copy the log file to the backup file
cp "$LOGFILE" "$BACKUP_FILE"

# Clear the log file
echo "" > "$LOGFILE"

#0 0 * * * /path/to/backup_nginx_log.sh
