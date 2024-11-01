#!/bin/bash

# Load environment variables from .env file
set -o allexport
source .env
set +o allexport

# Ensure the SSH directory exists
mkdir -p ~/.ssh

# Save the SSH private key from the environment variable and secure it
echo "${VM_SSH_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Add the firewall’s public IP to known hosts to avoid SSH prompt
ssh-keyscan -H "$FIREWALL_PUBLIC_IP" >> ~/.ssh/known_hosts
