#!/bin/bash

# Step 2: Open Backblaze app keys page
echo "Opening the Backblaze app keys page in your default browser..."
xdg-open "https://secure.backblaze.com/app_keys.htm"

# Step 3: Prompt the user for Backblaze credentials and bucket name
echo "Please generate an Application Key from the Backblaze page and provide the following details:"
read -p "Enter your Backblaze Account ID (KeyID): " B2_ACCOUNT_ID
read -sp "Enter your Backblaze Application Key: " B2_APP_KEY
echo
read -p "Enter your Backblaze Bucket Name: " B2_BUCKET_NAME

# Step 4: Prompt the user for encryption password
read -sp "Enter your encryption password: " PASSWORD
echo

# Variables for Rclone configuration
REMOTE_NAME="backblaze"  # Name of the remote
ENCRYPTED_REMOTE_NAME="encrypted-backblaze"

# Step 5: Create rclone config directory if it doesn't exist
mkdir -p ~/.config/rclone

# Step 6: Write to the rclone configuration file
cat <<EOL > ~/.config/rclone/rclone.conf
[$REMOTE_NAME]
type = b2
account = $B2_ACCOUNT_ID
key = $B2_APP_KEY
hard_delete = true
bucket = $B2_BUCKET_NAME

[$ENCRYPTED_REMOTE_NAME]
type = crypt
remote = $REMOTE_NAME:$B2_BUCKET_NAME
password = $(rclone obscure "$PASSWORD")
filename_encryption = standard
directory_name_encryption = true
EOL

# Step 7: Verify the configuration
echo "Rclone configuration completed. Testing the setup..."
rclone ls $ENCRYPTED_REMOTE_NAME: || echo "Error: Please check your configuration."
