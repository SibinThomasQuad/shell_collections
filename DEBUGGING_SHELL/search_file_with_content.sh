#!/bin/bash

# Define the directory to search in and the content to look for
search_directory="/path/to/search"
search_content="your_search_string"

# Use 'find' to search for files containing the content and 'grep' to filter results
found_files=$(find "$search_directory" -type f -exec grep -l "$search_content" {} +)

# Check if any files were found
if [ -z "$found_files" ]; then
  echo "No files containing '$search_content' found in $search_directory."
else
  echo "Files containing '$search_content' found:"
  echo "$found_files"
fi
