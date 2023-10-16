#!/bin/bash

# Function to recursively list permissions
list_permissions() {
  local directory="$1"
  local id="$2"
  local filepath="$3"
  
  # List permissions for all files and directories in the current directory
  for item in "$directory"/*; do
    local item_name=$(basename "$item")
    local item_path="$directory/$item_name"
    local item_permissions=$(stat -c "%a" "$item")

    # Print id, filepath, and permissions in the desired format
    echo "$id, $item_path, $item_permissions"

    # If the item is a directory, recursively list its contents
    if [ -d "$item" ]; then
      list_permissions "$item" "$id" "$item_path"
    fi
  done
}

# Usage: ./list_permissions.sh /path/to/directory
if [ $# -ne 1 ]; then
  echo "Usage: $0 /path/to/directory"
  exit 1
fi

# Check if the provided path is a directory
if [ ! -d "$1" ]; then
  echo "Error: '$1' is not a valid directory."
  exit 1
fi

# Output header
echo "id, filepath, permission"

# Start listing permissions from the provided directory
list_permissions "$1" "$(id -u)" "$1"
