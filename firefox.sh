#!/bin/bash

# Define the directory to search
firefox_dir="$HOME/.mozilla/firefox"

# Check if the directory exists
if [ -d "$firefox_dir" ]; then
    # Find the folder matching "*.default-release"
    default_release_folder=$(find "$firefox_dir" -maxdepth 1 -type d -name "*.default-release")

    # Check if a folder was found
    if [ -n "$default_release_folder" ]; then
        echo "Default-release folder found: $default_release_folder"

        # Fetch the latest tarball URL from arkenfox release API
        tarball_url=$(curl -s https://api.github.com/repos/arkenfox/user.js/releases/latest | grep "tarball_url" | cut -d '"' -f 4)

        # Check if the tarball URL was found
        if [ -n "$tarball_url" ]; then
            echo "Downloading tarball from: $tarball_url"

            # Download the tarball
            temp_dir=$(mktemp -d)
            tarball_path="$temp_dir/user.js.tar.gz"
            curl -L -o "$tarball_path" "$tarball_url"

            # Extract the tarball
            tar -xzf "$tarball_path" -C "$temp_dir"

            # Find the user.js file in the extracted contents
            user_js_file=$(find "$temp_dir" -type f -name "user.js")

            # Check if the user.js file was found
            if [ -n "$user_js_file" ]; then
                echo "Found user.js file: $user_js_file"

                # Move the user.js file to the default-release folder
                mv "$user_js_file" "$default_release_folder/"
                echo "Moved user.js to $default_release_folder"

                # Append additional preferences to the end of user.js
                echo "Appending additional preferences to user.js..."
                cat <<EOF >> "$default_release_folder/user.js"

user_pref("security.OCSP.enabled", 0);
user_pref("security.OCSP.require", false);
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.fingerprintingProtection.overrides", "+AllTargets,-JSDateTimeUTC");
user_pref("full-screen-api.warning.timeout", 0);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.tabs.hoverPreview.enabled", false);
EOF
                echo "Preferences appended successfully."

                # Create the chrome directory and userChrome.css file
                chrome_dir="$default_release_folder/chrome"
                mkdir -p "$chrome_dir"
                userChrome_file="$chrome_dir/userChrome.css"

                echo "Creating userChrome.css file..."
                cat <<EOF > "$userChrome_file"
/* Hide the "Passwords" menu item */
#appMenu-passwords-button {
    display: none !important;
}
EOF
                echo "userChrome.css file created successfully in $chrome_dir."
            else
                echo "user.js file not found in the tarball."
            fi

            # Clean up: delete the tarball and extracted contents
            rm -rf "$temp_dir"
            echo "Cleaned up temporary files."

        else
            echo "Failed to fetch tarball URL from the API."
        fi
    else
        echo "No default-release folder found in $firefox_dir."
    fi
else
    echo "The directory $firefox_dir does not exist."
fi