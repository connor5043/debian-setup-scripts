#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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
sudo apt install -y curl remind htop ncdu lynx neofetch zsh trash-cli alarm-clock-applet rclone oathtool keepassxc claws-mail claws-mail-fancy-plugin claws-mail-attach-warner netselect unzip unrar-free p7zip-full ruby-full recordmydesktop python3 python3-tk html2text jq build-essential golang todotxt-cli
gem install --user-install neocities

# zsh setup
chsh -s /usr/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

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
sudo apt install -y --no-install-recommends emacs
mkdir -p ~/.emacs.d
cd ~/.emacs.d
git clone -b master --single-branch https://github.com/ergoemacs/ergoemacs-mode.git
cd ~

sudo apt remove -y iio-sensor-proxy

# Proxy for redirections
sudo apt install -y nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
sudo cp reddit_redirect /etc/nginx/sites-available/reddit_redirect # TODO curl
#sudo openssl req -new -newkey rsa:2048 -nodes -keyout /etc/nginx/selfsigned.key -out /etc/nginx/selfsigned.csr
#echo "basicConstraints=CA:FALSE" > /tmp/basic_constraints.cnf
#sudo openssl x509 -req -days 3650 -in /etc/nginx/selfsigned.csr -signkey /etc/nginx/selfsigned.key -out /etc/nginx/selfsigned.crt -extfile /tmp/basic_constraints.cnf
#rm /tmp/basic_constraints.cnf
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/selfsigned.key \
    -out /etc/nginx/selfsigned.crt
sudo ln -s /etc/nginx/sites-available/reddit_redirect /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
echo "127.0.0.1 www.reddit.com" | sudo tee -a /etc/hosts
# TODO disable network.stricttransportsecurity.preloadlist

# TODO  update github files
# TODO install proxy.pac with postinst
# TODO firefox cert

sudo /usr/sbin/iptables -t nat -A OUTPUT -p tcp --dport 443 -d www.reddit.com -j REDIRECT --to-port 3128
sudo /usr/sbin/sysctl -w net.ipv4.ip_forward=1
# TODO setup proxy on firefox 127.0.0.1:3128


# Install Osatie
sudo mv osatie /opt/
mkdir -p ~/.config/sxhkd
echo '
control + space
  sh /opt/osatie/toggle_accent.sh
' | tee ~/.config/sxhkd/sxhkdrc

# Install media software
sudo apt install -y mpv clementine xfburn guvcview puddletag ffmpeg krita dia

# Install document software
sudo apt install -y libreoffice-writer libreoffice-calc libreoffice-impress zathura-pdf-poppler zathura-djvu zathura-ps pandoc ocrmypdf asciidoctor
curl -fsSL https://raw.githubusercontent.com/connor5043/Plin/refs/heads/main/install.sh | bash

# Install Android software
sudo apt install -y adb fastboot

# Install network software
sudo apt install -y vnstat transmission
sudo systemctl enable vnstat

# Install communication software
sudo apt install -y telegram-desktop libvpc-dev
curl -LO "https://github.com/BlueBubblesApp/bluebubbles-app/releases/download/v1.12.2%2B55/bluebubbles-linux-x86_64.tar"
mkdir -p ~/.local/opt/bluebubbles
tar xf bluebubbles-linux-x86_64.tar -C ~/.local/opt/bluebubbles
rm bluebubbles-linux-x86_64.tar
# TODO Desktop file
# TODO waydroid threema
# TODO anki to ~/.local/opt

curl -O "https://cdn.zoom.us/prod/$(curl -s 'https://zoom.us/rest/download?os=linux' | grep -oP '(?<="version":")[^"]*' | head -1)/zoom_amd64.deb"
#curl -O https://cdn.zoom.us/prod/6.3.11.7212/zoom_amd64.deb # later versions seem to be broken
sudo dpkg -i zoom_amd64.deb
sudo apt -f -y install
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

# Fix networking
sudo systemctl disable networking
sudo systemctl enable NetworkManager

