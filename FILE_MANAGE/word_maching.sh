#!/bin/bash

# Array of words to search for
words=("cat" "mouse" "rat")

# Folder to search in
folder="/path/to/your/folder"

# Function to find files containing words from the array
find_files_with_words() {
  local search_dir=$1
  local search_words=("${@:2}")

  for file in "$search_dir"/*; do
    if [ -f "$file" ]; then
      # Check if the file contains any of the words
      found=false
      for word in "${search_words[@]}"; do
        if grep -q "\<$word\>" "$file"; then
          found=true
          break
        fi
      done

      # If the file contains any of the words, print its name
      if [ "$found" = true ]; then
        echo "$file"
      fi
    fi
  done
}

# Call the function to find files containing the words
find_files_with_words "$folder" "${words[@]}"
