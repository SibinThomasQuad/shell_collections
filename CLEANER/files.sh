#!/bin/bash

# Directory to start the search from
search_dir="/path/to/your/directory"

# Read user input for the option
echo "Choose an option:"
echo "1. Search for files with specific extensions"
echo "2. Delete files with specific extensions"
echo "3. Empty a specific folder"
echo "4. List folders with a specific subfolder"
echo "5. Find files with size above a specific MB threshold"
echo "6. Delete files with size above a specific MB threshold"
read option

if [ "$option" = "1" ]; then
    # Read user input for extensions
    echo "Enter the extensions as comma-separated values (e.g., log,zip,sql):"
    read extensions

    # Convert comma-separated extensions to a find-compatible expression
    ext_expr=$(echo "$extensions" | sed 's/,/ -o -name \*./g')

    # Use find command to locate files with specified extensions in the specified directory and its subdirectories
    find "$search_dir" -type f \( -name "*.$ext_expr" \) -exec du -h {} \;
elif [ "$option" = "2" ]; then
    # Read user input for extensions
    echo "Enter the extensions as comma-separated values (e.g., log,zip,sql):"
    read extensions

    # Convert comma-separated extensions to a find-compatible expression
    ext_expr=$(echo "$extensions" | sed 's/,/ -o -name \*./g')

    # Delete files with specified extensions in the specified directory and its subdirectories
    find "$search_dir" -type f \( -name "*.$ext_expr" \) -exec rm -f {} \;
    echo "Deleted files with specified extensions."
elif [ "$option" = "3" ]; then
    # Read user input for the folder name
    echo "Enter the folder name to empty its contents:"
    read folder_name

    # Empty the contents of the specified folder
    find "$search_dir" -type d -name "$folder_name" -exec rm -r {}/* \;
    echo "Emptied the contents of folders named '$folder_name'."
elif [ "$option" = "4" ]; then
    # Read user input for the subfolder name
    echo "Enter the subfolder name to list folders with that subfolder:"
    read subfolder_name

    # List folders with the specified subfolder
    find "$search_dir" -type d -name "$subfolder_name" -exec dirname {} \; | sort -u | while read -r folder; do
        echo "Folder with '$subfolder_name': $folder"
    done
elif [ "$option" = "5" ]; then
    # Read user input for the size threshold
    echo "Enter the size threshold in MB:"
    read size_threshold

    # Find and list files with size above the specified threshold
    find "$search_dir" -type f -size +"$size_threshold"M -exec du -h {} \;
elif [ "$option" = "6" ]; then
    # Read user input for the size threshold
    echo "Enter the size threshold in MB:"
    read size_threshold

    # Find and delete files with size above the specified threshold
    find "$search_dir" -type f -size +"$size_threshold"M -print -exec rm -f {} \; | while read -r file; do
        echo "Deleted: $file"
    done
else
    echo "Invalid option."
fi
