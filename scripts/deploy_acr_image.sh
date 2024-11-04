#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package list and install Docker if not already installed
if ! command -v docker &> /dev/null; then
  echo "Docker not found, installing..."
  # Add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  # Set up the stable Docker repository
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  # Install Docker
  sudo apt-get install -y docker-ce
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

# Log in to Azure Container Registry (ACR)
# Make sure to replace the variables with actual values or pass them as environment variables
az acr login --name "$ACR_NAME"

# Pull the Docker image from ACR
docker pull "$ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG"

# Stop and remove any existing container with the same name
docker stop "$CONTAINER_NAME" || true
docker rm "$CONTAINER_NAME" || true

# Run a new container
docker run -d --name "$CONTAINER_NAME" -p 80:80 "$ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG"
