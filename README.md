# debian-setup-scripts
Setup for Debian 12

## Run the script
    sudo apt update; sudo apt upgrade
    sudo apt install -y ca-certificates git
    git clone https://github.com/connor5043/debian-setup-scripts
    cd debian-setup-scripts
    bash install.sh

## Post-installation
    Open and close Firefox once without internet, then, in zsh, run postinst.sh
    add sxhkd to Budgie startup
    Gajim: Quit on close, auto-delete messages
