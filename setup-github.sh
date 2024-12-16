#!/bin/bash

# Generate SSH key for GitHub
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "irwinschmitt@gmail.com" -f ~/.ssh/id_rsa -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    echo "SSH key generated. Please add the following public key to your GitHub account:"
    cat ~/.ssh/id_rsa.pub
else
    echo "SSH key already exists."
fi

# Set up global GitHub email and name
git config --global user.email "irwinschmitt@gmail.com"
git config --global user.name "Irwin Schmitt"
