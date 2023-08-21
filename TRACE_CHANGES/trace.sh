#!/bin/bash

# Title for the Modify Finder
echo "Modify Finder - Find Modified Files in Date Range"
echo "================================================="

# Read folder path, start date, and end date from the user
read -p "Enter folder path: " SEARCH_FOLDER
read -p "Enter start date (YYYY-MM-DD): " START_DATE
read -p "Enter end date (YYYY-MM-DD): " END_DATE

# Convert dates to Unix timestamps
START_TIMESTAMP=$(date -d "$START_DATE" +%s)
END_TIMESTAMP=$(date -d "$END_DATE" +%s)

echo ""
echo "Modified files in the date range $START_DATE to $END_DATE in folder $SEARCH_FOLDER:"
echo "--------------------------------------------------------------------------------"

# Define ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

count=0

# Find and list modified files within the date range
while IFS= read -r file; do
    modified_date=$(stat -c %y "$file" | cut -d ' ' -f 1)
    modified_time=$(stat -c %y "$file" | cut -d ' ' -f 2)
    count=$((count + 1))
    echo -e "${GREEN}$count.${NC}\t$file\t${RED}$modified_date $modified_time${NC}"
done < <(find "$SEARCH_FOLDER" -type f -newermt "$START_DATE" ! -newermt "$END_DATE" -print)

echo "--------------------------------------------------------------------------------"
echo -e "Total modified files found: ${YELLOW}$count${NC}"
