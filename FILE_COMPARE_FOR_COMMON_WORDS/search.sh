#!/bin/bash

# Check if both files are provided as arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 file1.txt file2.txt"
  exit 1
fi

# Get the file names from the command line arguments
file1="$1"
file2="$2"

# Function to highlight words in red
highlight_red() {
  local input="$1"
  echo -e "\e[31m$input\e[0m"
}

# Extract words from both files and count them
words_file1=$(grep -o -w '\w*' "$file1" | sort -u)
words_file2=$(grep -o -w '\w*' "$file2" | sort -u)

# Find matching words between the two sets
matching_words=""
serial_number=1
for word in $words_file1; do
  if grep -q -w "$word" "$file2"; then
    count_file1=$(grep -c -w "$word" "$file1")
    count_file2=$(grep -c -w "$word" "$file2")
    matching_words+="($serial_number) $(highlight_red "$word") - Count in $file1: $count_file1, Count in $file2: $count_file2\n"
    serial_number=$((serial_number + 1))
  fi
done

# Count the total number of matching words
total_matching_words=$(echo -e "$matching_words" | wc -l)

# Check if there are matching words
if [ "$total_matching_words" -gt 0 ]; then
  echo "Matching words between $file1 and $file2 (Total: $total_matching_words):"
  echo -e "$matching_words"
else
  echo "No matching words found."
fi
