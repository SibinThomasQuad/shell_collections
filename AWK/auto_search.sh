#!/bin/bash

# Function to prompt for a string
function prompt_for_string {
  read -p "Enter string $1: " string
  echo "$string"
}

# Prompt for the number of strings to search for
read -p "Enter the number of strings to search for: " string_count

# Array to store the strings
declare -a search_strings

# Prompt for each string
for (( i=1; i<=$string_count; i++ )); do
  search_strings[$i]=$(prompt_for_string $i)
done

# Prompt for the log file name
read -p "Enter the log file name: " logfile

# Use awk to search for lines containing all the specified strings
awk_expr="/${search_strings[1]}/"
for (( i=2; i<=$string_count; i++ )); do
  awk_expr="$awk_expr && /${search_strings[$i]}/"
done

awk "$awk_expr" "$logfile"
