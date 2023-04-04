#!/bin/bash

# Get current date
today=$(date +%Y-%m-%d)

# Set the backup directory
backup_dir="/path/to/backup/dir"

# Set MySQL credentials
mysql_user="username"
mysql_password="password"

# Backup only today's data
mysqldump -u $mysql_user -p$mysql_password --where="DATE_FORMAT(created_at, '%Y-%m-%d') = '$today'" database_name | gzip > $backup_dir/database_name_$today.sql.gz

# Remove backups older than 7 days
find $backup_dir/* -mtime +7 -exec rm {} \;
