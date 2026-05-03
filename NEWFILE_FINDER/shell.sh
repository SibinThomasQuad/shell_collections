#!/bin/bash

# ===== Colors =====
C_HEADER='\033[1;36m'
C_BORDER='\033[1;34m'
C_TEXT='\033[0;37m'
C_HIGHLIGHT='\033[1;32m'
C_ERROR='\033[1;31m'
C_RESET='\033[0m'

# ===== Table Widths =====
W_FILE=35
W_SIZE=10
W_DATE=20
W_MD5=32

# ===== Functions =====
draw_line() {
    printf "${C_BORDER}+"
    printf "%-${W_FILE}s" "" | tr ' ' '-'
    printf "+"
    printf "%-${W_SIZE}s" "" | tr ' ' '-'
    printf "+"
    printf "%-${W_DATE}s" "" | tr ' ' '-'
    printf "+"
    printf "%-${W_MD5}s" "" | tr ' ' '-'
    printf "+${C_RESET}\n"
}

print_row() {
    printf "${C_TEXT}| %-$(($W_FILE-1))s" "$1"
    printf "| %-$(($W_SIZE-1))s" "$2"
    printf "| %-$(($W_DATE-1))s" "$3"
    printf "| %-$(($W_MD5-1))s|${C_RESET}\n" "$4"
}

format_size() {
    numfmt --to=iec "$1" 2>/dev/null || echo "$1 B"
}

# ===== Header =====
clear
echo -e "${C_HEADER}📊 FILE SCAN REPORT${C_RESET}"

# ===== Inputs =====
echo -ne "${C_HIGHLIGHT}Enter directory: ${C_RESET}"
read scan_dir

if [ ! -d "$scan_dir" ]; then
    echo -e "${C_ERROR}Invalid directory!${C_RESET}"
    exit 1
fi

echo -ne "${C_HIGHLIGHT}Enter date (YYYY-MM-DD or '2 days ago'): ${C_RESET}"
read input_date

timestamp=$(date -d "$input_date" +%s 2>/dev/null)

if [ -z "$timestamp" ]; then
    echo -e "${C_ERROR}Invalid date!${C_RESET}"
    exit 1
fi

echo ""
echo -e "${C_HEADER}Directory: $scan_dir${C_RESET}"
echo -e "${C_HEADER}After: $input_date${C_RESET}"

# ===== Table Header =====
draw_line
print_row "FILE" "SIZE" "MODIFIED" "MD5"
draw_line

found=0

# ===== Scan =====
while IFS= read -r file; do
    mod_time=$(stat -c %Y "$file")

    if [ "$mod_time" -gt "$timestamp" ]; then
        found=1

        size=$(stat -c %s "$file")
        size_h=$(format_size "$size")
        mod_date=$(stat -c '%y' "$file" | cut -d'.' -f1)
        md5=$(md5sum "$file" | awk '{print $1}')

        rel_path="${file#$scan_dir/}"

        # Trim long names
        rel_path=$(echo "$rel_path" | cut -c1-$((W_FILE-2)))

        print_row "$rel_path" "$size_h" "$mod_date" "$md5"
    fi

done < <(find "$scan_dir" -type f 2>/dev/null)

# ===== Footer =====
if [ "$found" -eq 0 ]; then
    draw_line
    echo -e "${C_ERROR}No files found after given date.${C_RESET}"
else
    draw_line
    echo -e "${C_HIGHLIGHT}✔ Scan complete${C_RESET}"
fi
