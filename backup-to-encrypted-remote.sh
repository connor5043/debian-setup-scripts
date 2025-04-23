#!/bin/bash

# Variables
ENCRYPTED_REMOTE_NAME="encrypted-backblaze"
BACKUP_PATHS=(
  "~/Documents"
  "~/Music"
  "~/Videos"
  "~/.claws-mail"
  "~/.config/htop"
  "~/.config/keepassxc"
  "~/.config/libreoffice"
  "~/.zshrc"
  "~/.zshrc"
)

REMOTE_BACKUP_DIR="$ENCRYPTED_REMOTE_NAME:backups"

# Start the backup process
echo "Starting the backup process to $REMOTE_BACKUP_DIR..."

for PATH in "${BACKUP_PATHS[@]}"; do
  # Expand tilde (~) to the full home directory path
  EXPANDED_PATH=$(eval echo "$PATH")
  
  # Check if the file or directory exists
  if [[ -e "$EXPANDED_PATH" ]]; then
    echo "Backing up $EXPANDED_PATH..."
    /usr/bin/rclone sync --progress "$EXPANDED_PATH" "$REMOTE_BACKUP_DIR/$PATH"
  else
    echo "Warning: $EXPANDED_PATH does not exist. Skipping."
  fi
done

echo "Backup completed successfully!"
