# Quick desktop setup on Ubuntu Server

## What this does
This is an automatic way for me to set up Ubuntu on a computer to my preferences.

- Disables Bluetooth
- Replaces nano and vim with emacs (with ergoemacs mode)
- Installs Microsoft fonts and the Atkinson Hyperlegible Next font
- Installs the zsh shell and configures it to look like the fish shell
- Installs the Budgie desktop environment and configures it similarly to vanilla GNOME 3
- Installs various tools including Rclone, KeePassXC, Claws Mail, Krita, Transmission and Zathura
- Installs communication software such as Telegram, Threema, BlueBubbles and Zoom
- Installs qemu utilities and virtualization software for x86 systems
- Installs GNUjump and Minecraft (MultiMC) with Oracle Java
- Installs Firefox (automatically configured in post-installation)
- Sets up unattended upgrades

## Using the script
Make sure curl is installed!

    curl -fsSL https://raw.githubusercontent.com/connor5043/ubuntu-setup/refs/heads/main/install.sh | bash

### Post-installation
1. Open and close Firefox once without internet, then, in zsh, run postinst.sh
2. add sxhkd to Budgie startup
3. Open Firefox and type about:preferences in the address bar. Press Enter. In the "Applications" section, find "Portable Document Format (PDF)". Click the arrow next to "Action" and choose "Use another application" (e.g., Adobe Acrobat) or "Always ask"
