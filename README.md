# Post-Install Scripts

This repository contains a set of scripts to automate the post-installation setup of your system.

## How to Run

To run the post-install scripts, you can use the following `curl` command:

```bash
curl -sL https://raw.githubusercontent.com/irwinschmitt/post-install/main/post-install.sh | bash
```

This command will download and execute the `post-install.sh` script, which will in turn run all the necessary setup scripts.

## Scripts Included

- `upgrade.sh`: Updates and upgrades the system packages.
- `install-apps.sh`: Installs essential applications like Google Chrome, Visual Studio Code, Bitwarden, Slack, and Postman.
- `install-drivers.sh`: Installs necessary drivers.
- `setup-display.sh`: Configures display settings.
- `setup-github.sh`: Sets up GitHub SSH keys and global Git configuration.
- `install-zsh.sh`: Installs Zsh and Oh My Zsh, along with useful plugins.

## Additional Setup

- Creates `Work` and `Project` directories.
- Adds these directories to Nautilus bookmarks.
- Installs NVM (Node Version Manager).

Make sure to review the scripts and customize them as needed before running.
