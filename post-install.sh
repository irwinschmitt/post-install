#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Upgrade system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install applications
install_apps() {
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg &&
        sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ &&
        sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' &&
        rm -f packages.microsoft.gpg

    sudo apt-get update

    if ! command -v google-chrome &>/dev/null; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
        sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
        rm /tmp/google-chrome-stable_current_amd64.deb
        xdg-settings set default-web-browser google-chrome.desktop
        google-chrome "https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb" "https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep" "https://extensions.gnome.org/extension/6670/bluetooth-battery-meter/" &
    else
        echo "Google Chrome is already installed."
    fi

    if ! command -v code &>/dev/null; then
        wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/code_latest_amd64.deb
        sudo dpkg -i /tmp/code_latest_amd64.deb
        rm /tmp/code_latest_amd64.deb
        code &
    else
        echo "Visual Studio Code is already installed."
    fi

    if ! command -v bitwarden &>/dev/null; then
        wget "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -O /tmp/bitwarden_latest_amd64.deb
        sudo dpkg -i /tmp/bitwarden_latest_amd64.deb
        rm /tmp/bitwarden_latest_amd64.deb
        bitwarden &
    else
        echo "Bitwarden is already installed."
    fi

    if ! command -v docker &>/dev/null; then
        sudo apt install gnome-terminal
        sudo apt-get install -y ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt-get update
        wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb -O /tmp/docker-desktop.deb
        sudo apt-get install -y /tmp/docker-desktop.deb
        rm /tmp/docker-desktop.deb
        echo "Docker Desktop installed successfully."
    else
        echo "Docker is already installed."
    fi

    sudo apt-get install -y snapd
    sudo snap install slack --classic postman
    echo "Google Chrome, Visual Studio Code, Bitwarden, Slack, and Postman have been installed successfully."
    sudo apt-get install -y chrome-gnome-shell
    sudo apt-get install -f -y

    # Install Joplin
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
}

# Install drivers
install_drivers() {
    sudo ubuntu-drivers autoinstall
}

# Setup display
setup_display() {
    xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 60 --pos 0x0 --output DVI-D-0 --mode 1920x1080 --rate 60 --pos 1920x30
    wget -O ~/.config/monitors.xml https://gist.githubusercontent.com/irwinschmitt/a3964c902f71e8b301eb1f7cc46a5c7c/raw/b06a8e83d03f12b120cf5c667f6350d61857ef52/monitors.xml
    sudo cp ~/.config/monitors.xml /var/lib/gdm3/.config/monitors.xml
    sudo chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
}

# Setup GitHub
setup_github() {
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -C "irwinschmitt@gmail.com" -f ~/.ssh/id_rsa -N ""
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
        echo "SSH key generated. Please add the following public key to your GitHub account:"
        cat ~/.ssh/id_rsa.pub
    else
        echo "SSH key already exists."
    fi

    git config --global user.email "irwinschmitt@gmail.com"
    git config --global user.name "Irwin Schmitt"
}

# Install Zsh and Oh My Zsh
install_zsh() {
    sudo apt-get install -y zsh
    export RUNZSH=no
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' ~/.zshrc
    chsh -s $(which zsh)
}

# Create directories and add to bookmarks
setup_directories() {
    mkdir -p ~/Work ~/Project

    bookmark_file="$HOME/.config/gtk-3.0/bookmarks"
    if ! grep -q "file://$HOME/Work Work" "$bookmark_file"; then
        echo "file://$HOME/Work Work" >>"$bookmark_file"
    fi
    if ! grep -q "file://$HOME/Project Project" "$bookmark_file"; then
        echo "file://$HOME/Project Project" >>"$bookmark_file"
    fi
}

# Install NVM (Node Version Manager)
install_nvm() {
    NVM_LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST_VERSION}/install.sh" | bash
}

# Execute all functions
install_apps
install_drivers
setup_display
setup_github
install_zsh
setup_directories
install_nvm
