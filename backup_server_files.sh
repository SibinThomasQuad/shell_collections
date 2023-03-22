#!/bin/bash

# Define the source and destination directories
src_dir="/path/to/source/directory"
dest_dir="/path/to/destination/directory"

# Define the backup file name and path
backup_file="$(date +%Y-%m-%d-%H-%M-%S)-backup.tar.gz"
backup_path="${dest_dir}/${backup_file}"

# Create the destination directory if it doesn't exist
mkdir -p "${dest_dir}"

# Backup the source directory to the destination directory
rsync -av --delete "${src_dir}/" "${dest_dir}"

# Compress the backup file using tar and gzip
tar -czvf "${backup_path}" "${dest_dir}"

# Delete old backup files (keep the last 7 backups)
ls -tp "${dest_dir}" | grep -v '/$' | tail -n +8 | xargs -I {} rm -- "${dest_dir}/{}"


#30 2 * * * /path/to/backup.sh

