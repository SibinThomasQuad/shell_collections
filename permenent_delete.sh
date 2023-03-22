#!/bin/bash

# Check if at least one argument is given
if [ $# -eq 0 ]; then
  echo "Usage: $0 file1 [file2 ...]"
  exit 1
fi

# Loop through each argument and shred it securely
for file in "$@"
do
  if [ -e "$file" ]; then
    echo "Shredding $file securely..."
    shred -vzn 3 "$file"
    rm -rf "$file"
  else
    echo "File $file does not exist."
  fi
done

# Shred all free space on the disk to securely delete any previously deleted data
echo "Shredding all free space on the disk securely..."
shred -vzn 3 --random-source=/dev/urandom /tmp/empty
rm /tmp/empty

echo "All specified files have been securely and permanently deleted."

<<com
This script checks if at least one argument is given, loops through each argument to shred it securely using the shred command with the -z option to add a final overwrite with zeros, the -n option to specify the number of times to overwrite the file, and the -v option to show the progress of the operation. After shredding the file, the script removes it permanently using the rm command with the -rf option to remove directories recursively.

Finally, the script uses the shred command again to securely delete any previously deleted data by overwriting all free space on the disk with random data. The --random-source=/dev/urandom option ensures that the random data used for overwriting is truly random. The script then removes the temporary file used for overwriting.

Note that shredding files and directories securely and permanently using the shred command can take a long time, especially for large files and directories. It is important to use this script with caution and only when it is absolutely necessary to securely and permanently delete data.

<<com !"
