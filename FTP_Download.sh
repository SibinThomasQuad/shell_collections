#!/bin/bash

# Set FTP server details
FTP_SERVER="ftp.example.com"
FTP_USERNAME="username"
FTP_PASSWORD="password"

# Set remote folder path and local download path
REMOTE_FOLDER_PATH="/remote_folder"
LOCAL_DOWNLOAD_PATH="/local_folder"

# Connect to FTP server and download folder
ftp -n $FTP_SERVER <<END_SCRIPT
quote USER $FTP_USERNAME
quote PASS $FTP_PASSWORD
binary
cd $REMOTE_FOLDER_PATH
lcd $LOCAL_DOWNLOAD_PATH
mget *
quit
END_SCRIPT
exit 0
