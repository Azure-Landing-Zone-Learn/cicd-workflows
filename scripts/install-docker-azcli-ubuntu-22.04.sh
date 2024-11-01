#!/bin/bash

# Update package list and install Docker if not already installed
if ! command -v docker &> /dev/null; then
  echo "Docker not found, installing..."
  # Add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  # Set up the stable Docker repository
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  # Install Docker
  sudo apt install -y docker-ce
  # Start and enable Docker to start on boot
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "Docker installed successfully."
else
  echo "Docker is already installed."
fi

# Install Azure CLI if not already installed
if ! command -v az &> /dev/null; then
  echo "Azure CLI not found, installing..."
  # Run the Azure CLI installation script
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  echo "Azure CLI installed successfully."
else
  echo "Azure CLI is already installed."
fi