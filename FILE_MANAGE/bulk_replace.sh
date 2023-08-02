#!/bin/bash

# Replace "30 PREMIUM GAMES COLLECTIONS" with "70 PREMIUM GAMES COLLECTIONS" in all HTML files
find /path/to/html/files -type f -name "*.html" -exec sed -i 's/30 PREMIUM GAMES COLLECTIONS/70 PREMIUM GAMES COLLECTIONS/g' {} \;

echo "Replacement complete. The text has been updated in all HTML files."
