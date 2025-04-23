## Setting up backups
`bash configure-rclone-interactive.sh`

## Backing up
`bash backup-to-encrypted-remote.sh`

## Restoring
`rclone copy -P encrypted-backblaze:backups/~/ ~`
