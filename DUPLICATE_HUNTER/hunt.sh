#!/bin/bash

declare -A file_hashes
total_duplicates=0

# Function to process files and folders in a directory
process_directory() {
    local directory="$1"
    for entry in "$directory"/*; do
        if [ -f "$entry" ] || [ -d "$entry" ]; then
            if [ -f "$entry" ]; then
                size=$(du -h "$entry" | awk '{ print $1 }')
                created_date=$(stat -c %x "$entry")
                hash=$(md5sum "$entry" | cut -d ' ' -f 1)
                if [ -n "${file_hashes[$hash]}" ]; then
                    original_file=${file_hashes[$hash]}
                    original_size=$(du -h "$original_file" | awk '{ print $1 }')
                    ((total_duplicates++))
                    print_table "$entry" "$original_file" "$size" "$original_size" "$created_date"
                else
                    file_hashes["$hash"]=$entry
                fi
            elif [ -d "$entry" ]; then
                num_items=$(find "$entry" -mindepth 1 | wc -l)
                size=$(du -h -s "$entry" | awk '{ print $1 }')
                created_date=$(stat -c %x "$entry")
                print_table "$entry (Folder)" "" "$size" "" "$created_date"
            fi
        fi

        if [ -d "$entry" ]; then
            process_directory "$entry"
        fi
    done
}

# Function to print a table row
print_table() {
    local entry_color="\e[32m"
    if [ -n "$2" ]; then
        entry_color="\e[31m"
    fi
    printf "| %-40s | $entry_color%-40s\e[0m | %-8s | %-12s | %-20s |\n" "$1" "$2" "$3" "$4" "$5"
}

# Main script
read -p "Enter the folder path: " search_directory

if [ ! -d "$search_directory" ]; then
    echo "Error: $search_directory is not a valid directory."
    exit 1
fi

echo -e "\e[1;34mDuplicate Hunter\e[0m"
echo "=============================================================================================================="
printf "| %-40s | %-40s | %-8s | %-12s | %-20s |\n" "Entry" "Original File" "Size" "Original Size" "Created Date"
echo "=============================================================================================================="

process_directory "$search_directory"

echo "=============================================================================================================="
echo "Total Duplicate Files: $total_duplicates"
