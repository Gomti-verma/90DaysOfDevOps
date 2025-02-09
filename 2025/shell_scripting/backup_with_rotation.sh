#!/bin/bash

# Check if the directory argument is provided
if [ -z "$1" ]; then
    echo "Please provide a directory path."
    exit 1
fi

DIR_PATH=$1

# Get the current timestamp
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')

# Create the backup folder
BACKUP_FOLDER="${DIR_PATH}/backup_${TIMESTAMP}"

# Create the backup folder
mkdir "$BACKUP_FOLDER"

# Copy the contents of the directory to the backup folder
cp -r "$DIR_PATH"/* "$BACKUP_FOLDER"
echo "Backup created: $BACKUP_FOLDER"

# Get a list of all backup directories
BACKUP_DIRS=$(ls -d ${DIR_PATH}/backup_*)

# Count the number of backup directories
BACKUP_COUNT=$(echo "$BACKUP_DIRS" | wc -l)

# If there are more than 3 backups, remove the oldest ones
if [ "$BACKUP_COUNT" -gt 3 ]; then
    # Get the oldest backups to remove
    OLDEST_BACKUPS=$(echo "$BACKUP_DIRS" | sort | head -n $(($BACKUP_COUNT - 3)))

    # Remove the oldest backups
    for BACKUP in $OLDEST_BACKUPS; do
        rm -rf "$BACKUP"
        echo "Removed old backup: $BACKUP"
    done
fi
