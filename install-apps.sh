#!/bin/bash

# Add the Visual Studio Code repository and key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg &&
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ &&
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' &&
    rm -f packages.microsoft.gpg

# Update the package list again
sudo apt-get update

# Check if Google Chrome is installed
if ! command -v google-chrome &>/dev/null; then
    # Download the latest Google Chrome .deb package
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
    # Install Google Chrome
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
    # Clean up
    rm /tmp/google-chrome-stable_current_amd64.deb
    # Open Google Chrome with tabs for Bitwarden extension and GNOME Shell extension link

    xdg-settings set default-web-browser google-chrome.desktop

    google-chrome \
        "https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb" \
        "https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep" \
        "https://extensions.gnome.org/extension/6670/bluetooth-battery-meter/" &
else
    echo "Google Chrome is already installed."
fi

# Check if Visual Studio Code is installed
if ! command -v code &>/dev/null; then
    # Download the latest VSCode .deb package
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/code_latest_amd64.deb
    # Install Visual Studio Code
    sudo dpkg -i /tmp/code_latest_amd64.deb
    # Clean up
    rm /tmp/code_latest_amd64.deb
    # Open Visual Studio Code
    code &
else
    echo "Visual Studio Code is already installed."
fi

# Check if Bitwarden is installed
if ! command -v bitwarden &>/dev/null; then
    # Download the latest Bitwarden .deb package
    wget "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -O /tmp/bitwarden_latest_amd64.deb
    # Install Bitwarden
    sudo dpkg -i /tmp/bitwarden_latest_amd64.deb
    # Clean up
    rm /tmp/bitwarden_latest_amd64.deb
    # Open Bitwarden
    bitwarden &
else
    echo "Bitwarden is already installed."
fi

if ! command -v docker &>/dev/null; then
    sudo apt install gnome-terminal

    # Install required packages
    sudo apt-get install -y ca-certificates curl
    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    # Update the package list again
    sudo apt-get update
    # Download the latest Docker Desktop DEB package
    wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb -O /tmp/docker-desktop.deb
    # Install Docker Desktop
    sudo apt-get install -y /tmp/docker-desktop.deb
    # Clean up
    rm /tmp/docker-desktop.deb
    echo "Docker Desktop installed successfully."
else
    echo "Docker is already installed."
fi

# Install Snap
sudo apt-get install -y snapd

# Install Slack using Snap
sudo snap install slack --classic postman

echo "Google Chrome, Visual Studio Code, Bitwarden, Slack, and Postman have been installed successfully."

sudo apt-get install -y chrome-gnome-shell

sudo apt-get install -f -y
