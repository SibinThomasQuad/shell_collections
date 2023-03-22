#!/bin/bash

# Define the database credentials
db_user="username"
db_pass="password"
db_name="database_name"

# Define the backup file name and path
backup_file="$(date +%Y-%m-%d-%H-%M-%S)-backup.sql.gz"
backup_path="/path/to/backup/directory/${backup_file}"

# Create the backup directory if it doesn't exist
mkdir -p "/path/to/backup/directory"

# Backup the database using mysqldump
mysqldump -u "${db_user}" -p"${db_pass}" "${db_name}" | gzip > "${backup_path}"

# Delete old backup files (keep the last 7 backups)
ls -tp "/path/to/backup/directory" | grep -v '/$' | tail -n +8 | xargs -I {} rm -- "/path/to/backup/directory/{}"

#Here's how the script works:

#    Define the database credentials (replace username, password, and database_name with your actual credentials).
#    Define the backup file name and path using the current date and time.
#    Create the backup directory if it doesn't exist.
#    Use mysqldump to create a backup of the MySQL database and pipe the output to gzip to compress the backup file.
#    Delete old backup files (keep the last 7 backups) using ls, grep, tail, and xargs.

#You can save this script in a file, e.g. db-backup.sh, make it executable with chmod +x db-backup.sh, and run it #manually or schedule
