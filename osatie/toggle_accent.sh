#!/bin/sh

# Path to xmodmap files
ACUTE_XMODMAP="/opt/osatie/acute.xmodmap"
GRAVE_XMODMAP="/opt/osatie/grave.xmodmap"

# File to store the current state
STATE_FILE=".current_accent_state"

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "acute" > "$STATE_FILE"
fi

# Read the current state
CURRENT_STATE=$(cat "$STATE_FILE")

# Toggle the state and apply the corresponding xmodmap file
if [ "$CURRENT_STATE" = "acute" ]; then
    xmodmap "$GRAVE_XMODMAP"
    echo "grave" > "$STATE_FILE"
    echo "Switched to grave accents"
else
    xmodmap "$ACUTE_XMODMAP"
    echo "acute" > "$STATE_FILE"
    echo "Switched to acute accents"
fi
