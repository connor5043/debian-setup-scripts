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

# yt-dlp
echo "deb http://deb.debian.org/debian/ sid main" | sudo tee -a /etc/apt/sources.list # for yt-dlp
echo '
Package: *
Pin: release n=bookworm
Pin-Priority: 700

Package: *
Pin: release n=sid
Pin-Priority: -10
' | sudo tee /etc/apt/preferences
sudo apt update

# Install utilities
sudo apt install -y curl ne remind htop ncdu lynx neofetch zsh trash-cli alarm-clock-applet rclone oathtool keepassxc claws-mail claws-mail-fancy-plugin claws-mail-attach-warner netselect unzip unrar-free p7zip-full ruby-full recordmyscreen python3 html2text
gem install --user-install neocities
curl -fsSL https://raw.githubusercontent.com/connor5043/Plin/refs/heads/main/install.sh | bash

# zsh setup
chsh -s /usr/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
sed -i "s/zstyle ':prezto:module:prompt' theme 'sorin'/zstyle ':prezto:module:prompt' theme 'off'/" ~/.zpreztorc

# Install Atkinson Hyperlegible Next
curl -L -O https://braileinstitute.box.com/shared/static/waaf5z9gfss6w6tf5118im5hhlwolacc.zip
unzip waaf5z9gfss6w6tf5118im5hhlwolacc.zip
mkdir -p ~/.local/share/fonts/otf/Atkinson_Hyperlegible_Next
cp Atkinson\ Hyperlegible\ Next/*.otf ~/.local/share/fonts/otf/Atkinson_Hyperlegible_Next && fc-cache
rm -r Atkinson\ Hyperlegible\ Next
rm waaf5z9gfss6w6tf5118im5hhlwolacc.zip

# Install the desktop
sudo apt install -y lightdm
sudo apt install -y --no-install-recommends xinit budgie-desktop gnome-terminal
sudo apt install -y budgie-applications-menu-applet budgie-hotcorners-applet budgie-previews
sudo apt install -y sxhkd sxiv caja pluma pluma-plugin-terminal mate-calc nautilus
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
gsettings set org.mate.pluma highlight-current-line true
gsettings set org.mate.pluma display-line-numbers true
gsettings set org.mate.pluma display-overview-map true

# Configure Pluma
gsettings set org.mate.pluma color-scheme 'oblivion'
gsettings set org.mate.pluma editor-font 'Atkinson Hyperlegible Next 15'

dconf load /com/solus-project/budgie-panel/ < budgie-panel.ini
dconf load /org/ubuntubudgie/plugins/budgie-hotcorners/ < budgie-corners.ini

# Install Osatie
sudo mv osatie /opt/
echo '
control + space
  sh /opt/osatie/toggle_accent.sh
' | sudo tee ~/.config/sxhkd/sxhkdrc

# Install media software
sudo apt install -y mpv clementine xfburn guvcview puddletag ffmpeg gimp krita dia

# Install document software
sudo apt install -y libreoffice-writer libreoffice-calc libreoffice-impress zathura-pdf-poppler zathura-djvu zathura-ps pandoc ocrmypdf asciidoctor

# Install Android software
sudo apt install -y adb fastboot

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

# curl -O "https://cdn.zoom.us/prod/$(curl -s 'https://zoom.us/rest/download?os=linux' | grep -oP '(?<="version":")[^"]*' | head -1)/zoom_amd64.deb"
curl -O https://cdn.zoom.us/prod/6.3.11.7212/zoom_amd64.deb # later versions seem to be broken
sudo dpkg -i zoom_amd64.deb
sudo apt -f install
rm zoom_amd64.deb

# Install virtualization software
sudo apt install -y qemu-utils qemu-system-x86 qemu-system-gui

# Install games
sudo apt install -y gnujump libqt5core5a libqt5network5 libqt5gui5 # dependencies for MultiMC
echo "NoDisplay=true" | sudo tee -a /usr/share/applications/gnujump.desktop
curl -O $(curl https://multimc.org/ | grep .deb | sed -n 's/.*href="\([^"]*multimc_.*\.deb\)".*/\1/p')
sudo dpkg -i multimc*.deb
rm multimc*.deb

# Install latest Oracle Java
curl -O $(curl -s https://www.oracle.com/java/technologies/downloads/ | grep -oP 'https://.*?\.deb' | head -n 1)
sudo dpkg -i jdk*bin.deb
rm jdk*bin.deb

# yt-dlp
sudo apt install -y -t sid yt-dlp

# Install Firefox
sudo install -d -m 0755 /etc/apt/keyrings
curl -s https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | \
awk '/pub/ {
    getline; 
    gsub(/^ +| +$/, ""); 
    if ($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") {
        print "\nThe key fingerprint matches (" $0 ").\n";
    } else {
        print "\nVerification failed: the fingerprint (" $0 ") does not match the expected one.\n";
        exit 1;
    }
}'

if [ $? -ne 0 ]; then
    echo "Fingerprint verification failed. Exiting script."
    exit 1
fi

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt update

sudo apt install -y firefox

# TODO Set up unattended upgrades

# TODO vpn + socks5

# TODO for archive.org-downloader: python3-img2pdf, python3-pycryptodome python3-tqdm python3-requests

# Set password for root (to be kept on paper) and remove user from sudoers

# Step 1: Generate a random 32-character password
ROOT_PASSWORD=$(openssl rand -base64 32 | head -c 32)
echo "Generated root password: $ROOT_PASSWORD"

# Step 2: Set the root password
echo "root:$ROOT_PASSWORD" | sudo chpasswd

# Step 3: Remove yourself from the sudoers group
sudo usermod -G "$(id -Gn | sed 's/sudo//g')" "$USER"

# Inform the user
echo "You have been removed from the sudoers group. Save the root password securely!"
