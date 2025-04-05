#!/bin/bash

sudo systemctl disable bluetooth
sudo apt purge -y bluetooth bluez nano vim-common vim-tiny
sudo apt autoremove -y --purge

# Install Microsoft fonts
sudo cp /etc/apt/sources.list /etc/apt/sources.list.9
sudo sed -r -i 's/^deb(.*)$/deb\1 contrib/g' /etc/apt/sources.list
sudo apt update
sudo apt install -y ttf-mscorefonts-installer
sudo mv /etc/apt/sources.list.9 /etc/apt/sources.list
sudo apt update

# Install utilities
sudo apt install -y curl ne remind htop ncdu python3.11 python-gi-dev libgtk-4-dev libadwaita-1-dev lynx neofetch zsh trash-cli tor alarm-clock-applet rclone keepassxc thunderbird
# replace neofetch with fastfetch in debian 13
# python stuff is for Plin
chsh -s /usr/bin/zsh
sudo systemctl enable tor

# Necessary for my morning scripts
sudo apt install -y html2text

# Install Anki
sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3 python3.11-venv
python3 -m venv pyenv
pyenv/bin/pip install --upgrade pip
pyenv/bin/pip install --upgrade --pre 'aqt[qt6]'

# curl -s https://apps.ankiweb.net/ | grep -oP 'https://github.com/ankitects/anki/releases/download/[0-9.]+/anki-[0-9.]+-linux-qt6.tar.zst' | xargs curl -L -o anki-latest-linux-qt6.tar.zst
# tar xaf anki-latest-linux-qt6.tar.zst
# rm anki-latest-linux-qt6.tar.zst
#cd anki*qt6
# sudo ./install.sh
# cd ..
# rm -r anki*qt6

# Install the desktop
sudo apt install -y xinit
sudo apt install -y --no-install-recommended budgie-desktop
sudo apt install -y budgie-applications-menu-applet budgie-hotcorners-applet budgie-previews
sudo apt install -y sxhkd sxiv caja pluma emacs mate-calc nautilus
sudo apt remove -y iio-sensor-proxy
gsettings set org.gnome.settings-daemon.peripherals.touchscreen orientation-lock true

# Configure Budgie settings
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['\<Alt\>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['\<Shift\>\<Alt\>Tab', '\<Alt\>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
gsettings set org.gnome.desktop.privacy remember-app-usage false
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.desktop.interface clock-format 12h
gsettings set org.gtk.settings.file-chooser clock-format 12h
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set desktop.ibus.panel.show-icon-on-systray false # disable keyboard switcher

dconf load /com/solus-project/budgie-panel/ < budgie-panel.ini
dconf load /org/ubuntubudgie/plugins/budgie-hotcorners/ < budgie-corners.ini

# Install media software
sudo apt install -y mpv clementine xfburn guvcview puddletag ffmpeg gimp dia

# Install document software
sudo apt install -y libreoffice-writer libreoffice-calc libreoffice-impress ocrmypdf mupdf

# Install QOwnNotes
SIGNED_BY='/etc/apt/keyrings/qownnotes.gpg'
sudo mkdir -p "$(dirname "${SIGNED_BY}")"
curl --silent --show-error --location http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_12/Release.key | gpg --dearmor | sudo tee "${SIGNED_BY}" > /dev/null
sudo chmod u=rw,go=r "${SIGNED_BY}"
echo "deb [arch=${ARCHITECTURE} signed-by=${SIGNED_BY}] http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_12/ /" | sudo tee /etc/apt/sources.list.d/qownnotes.list > /dev/null
sudo apt update
sudo apt install -y qownnotes

# Install network software
sudo apt install -y vnstat transmission
sudo systemctl enable vnstat

# Install communication software
sudo apt install -y gajim

curl -O "https://cdn.zoom.us/prod/$(curl -s 'https://zoom.us/rest/download?os=linux' | grep -oP '(?<="version":")[^"]*' | head -1)/zoom_amd64.deb"
sudo dpkg -i zoom_amd64.deb
sudo apt -f install
rm zoom_amd64.deb
# sed -i 's|Exec=/usr/bin/zoom %U|Exec=/usr/bin/zoom --disable-gpu-sandbox %U|' ~/.local/share/applications/Zoom.desktop

# Install virtualization software
sudo apt install -y qemu-utils qemu-system-x86 qemu-system-gui
