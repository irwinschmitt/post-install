#!/bin/bash

# Apply display settings for the current session
xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 60 --pos 0x0 --output DVI-D-0 --mode 1920x1080 --rate 60 --pos 1920x30

# Download monitors.xml from the provided link
wget -O ~/.config/monitors.xml https://gist.githubusercontent.com/irwinschmitt/a3964c902f71e8b301eb1f7cc46a5c7c/raw/b06a8e83d03f12b120cf5c667f6350d61857ef52/monitors.xml

# Apply display settings for the login screen
sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config/monitors.xml
sudo chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
