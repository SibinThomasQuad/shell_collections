#!/bin/bash

# Set the source file path and server details
SOURCE_FILE="/path/to/source/file"
REMOTE_USER="remote_username"
REMOTE_HOST="remote_host"
REMOTE_PATH="/path/to/remote/directory"

# Copy the file using scp
scp $SOURCE_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH

