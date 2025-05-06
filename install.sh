#!/bin/bash

# Function to disable Bluetooth
disable_bluetooth() {
    echo "Disabling Bluetooth..."
    if /usr/bin/defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0; then
        echo "Bluetooth disabled successfully. You may need to restart your Mac for changes to take effect."
    else
        echo "Failed to disable Bluetooth. Please check your permissions."
    fi
}

# Function to install Homebrew
install_homebrew() {
    echo "Checking if Homebrew is already installed..."
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed."
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            echo "Failed to install Homebrew. Please check your internet connection or try again."
            exit 1
        }
        echo "Homebrew installed successfully."
    fi
}

# Function to install packages with Homebrew
install_packages() {
    echo "Installing packages with Homebrew..."
    brew install curl ne remind htop ncdu lynx fastfetch trash-cli rclone claws-mail unzip p7zip ruby python python-tk pyqt \
        html2text jq emacs mpv ffmpeg pandoc ocrmypdf asciidoctor vnstat yt-dlp || {
        echo "Failed to install some packages. Please check the error messages."
        exit 1
    }
    echo "All requested packages installed successfully."

    echo "Installing Python packages pyparsing and mutagen using pip..."
    pip3 install pyparsing mutagen || {
        echo "Failed to install Python packages. Please check your Python and pip installation."
        exit 1
    }
    echo "Python packages installed successfully."
}

# Function to install apps from the cask tap
install_cask_apps() {
    echo "Installing GUI applications with Homebrew cask..."
    brew tap homebrew/cask-fonts
    brew install --cask telegram-desktop gimp krita libreoffice transmission quodlibet qownnotes zoom multimc oracle-jdk \
        font-atkinson-hyperlegible-next || {
        echo "Failed to install some cask applications. Please check the error messages."
        exit 1
    }
    echo "All requested cask applications installed successfully."
}

# Function to install the 'neocities' Ruby gem
install_neocities_gem() {
    echo "Installing the 'neocities' Ruby gem with --user-install..."
    if gem install neocities --user-install; then
        echo "The 'neocities' gem installed successfully."
    else
        echo "Failed to install the 'neocities' gem. Please check your Ruby installation or permissions."
        exit 1
    fi
}

# Function to set up Zsh with Oh My Zsh and Prezto
setup_zsh() {
    echo "Setting up Zsh with Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
        echo "Failed to install Oh My Zsh. Please check your internet connection or try again."
        exit 1
    }
    echo "Oh My Zsh installed successfully."

    echo "Cloning Prezto repository..."
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || {
        echo "Failed to clone Prezto repository. Please check your Git installation or internet connection."
        exit 1
    }
    echo "Prezto repository cloned successfully."
}

# Function to install Zathura and its plugins
install_zathura() {
    echo "Installing Zathura and its plugins..."
    brew tap homebrew-zathura/zathura || {
        echo "Failed to tap the Zathura repository. Please check your internet connection."
        exit 1
    }

    brew install zathura zathura-pdf-mupdf zathura-djvu zathura-ps || {
        echo "Failed to install Zathura or its plugins. Please check for errors."
        exit 1
    }
    echo "Zathura and its plugins installed successfully."
}

# Function to download and install Threema Desktop
install_threema() {
    echo "Installing Threema Desktop..."
    THREEMA_URL="https://releases.threema.ch/web-electron/v1/release/Threema-Latest.dmg"
    THREEMA_DMG="Threema-Latest.dmg"

    echo "Downloading Threema Desktop..."
    curl -L -O "$THREEMA_URL" || {
        echo "Failed to download Threema Desktop. Please check your internet connection."
        exit 1
    }

    echo "Mounting Threema DMG..."
    hdiutil attach "$THREEMA_DMG" || {
        echo "Failed to mount Threema DMG. Please check the downloaded file."
        exit 1
    }

    echo "Installing Threema Desktop..."
    cp -R /Volumes/Threema\ Desktop/Threema\ Desktop.app /Applications || {
        echo "Failed to copy Threema Desktop to the Applications folder."
        exit 1
    }

    echo "Cleaning up..."
    hdiutil detach /Volumes/Threema\ Desktop || {
        echo "Failed to unmount Threema DMG."
    }
    rm "$THREEMA_DMG"

    echo "Threema Desktop installed successfully."
}

# Function to install Puddletag
install_puddletag() {
    echo "Installing Puddletag..."
    curl -L -o puddletag-latest.tar.gz "$(curl -s https://api.github.com/repos/puddletag/puddletag/releases/latest | grep "tarball_url" | cut -d '"' -f 4)" || {
        echo "Failed to download Puddletag. Please check your internet connection."
        exit 1
    }

    mkdir -p puddletag-temp
    tar -xzf puddletag-latest.tar.gz -C puddletag-temp || {
        echo "Failed to extract the Puddletag archive."
        exit 1
    }

    mkdir -p ~/.opt/puddletag
    mv puddletag-temp/$(ls puddletag-temp)/* ~/.opt/puddletag || {
        echo "Failed to move Puddletag files to the target directory."
        exit 1
    }

    echo "Cleaning up temporary files..."
    rm -rf puddletag-latest.tar.gz puddletag-temp

    echo "Puddletag installed successfully."
}

# Main script execution
disable_bluetooth
install_homebrew
install_packages
install_cask_apps
install_neocities_gem
setup_zsh
install_zathura
install_threema
install_puddletag

echo "Script execution completed."