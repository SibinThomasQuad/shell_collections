#!/bin/bash

# Set cPanel server details
CPANEL_SERVER="example.com"
CPANEL_USERNAME="username"
CPANEL_PASSWORD="password"

# Set remote directory path and local download path
REMOTE_DIR_PATH="/public_html"
LOCAL_DOWNLOAD_PATH="/local_folder"

# Connect to cPanel server and download files (excluding zip files)
wget -r -nH --cut-dirs=1 --no-parent --reject="*.zip" -P $LOCAL_DOWNLOAD_PATH --user=$CPANEL_USERNAME --password=$CPANEL_PASSWORD ftp://$CPANEL_SERVER$REMOTE_DIR_PATH/
