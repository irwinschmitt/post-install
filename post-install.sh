#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

./upgrade.sh
./install-apps.sh
./install-drivers.sh
./setup-display.sh
./setup-ssh.sh
./install-zsh.sh

# Create directories Work and Project
mkdir -p ~/Work ~/Project

# Add directories to Nautilus bookmarks
echo "file://$HOME/Work Work" >>~/.config/gtk-3.0/bookmarks
echo "file://$HOME/Project Project" >>~/.config/gtk-3.0/bookmarks

# Install NVM (Node Version Manager)
NVM_LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST_VERSION}/install.sh" | bash
