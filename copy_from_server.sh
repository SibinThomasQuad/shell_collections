#!/bin/bash

# Set the remote file path and server details
REMOTE_FILE="/path/to/remote/file"
REMOTE_USER="remote_username"
REMOTE_HOST="remote_host"
LOCAL_PATH="/path/to/local/directory"

# Download the file using scp
scp $REMOTE_USER@$REMOTE_HOST:$REMOTE_FILE $LOCAL_PATH

