#!/bin/bash

echo "Starting deployment process..."

# Ensure SSH agent is running
if [ -z "$SSH_AUTH_SOCK" ]; then
  echo "Starting SSH agent..."
  eval $(ssh-agent)
  
  # Use the correct key name (assuming ed25519 was intended)
  ssh-add ~/.ssh/do_ed25519
  
  # If key doesn't exist with that name, try to find the correct key
  if [ $? -ne 0 ]; then
    echo "Key not found. Listing available keys in ~/.ssh:"
    ls -la ~/.ssh/ | grep -i "do_" || echo "No Digital Ocean keys found."
    exit 1
  fi
fi

# Remove existing host keys to avoid "HOST IDENTIFICATION HAS CHANGED" errors
echo "Removing any existing host keys for our servers..."
ssh-keygen -f ~/.ssh/known_hosts -R "164.92.182.107" || true  # bastion/jumpbox
ssh-keygen -f ~/.ssh/known_hosts -R "10.10.1.2" || true  # multi-app1
ssh-keygen -f ~/.ssh/known_hosts -R "10.10.1.4" || true  # nodejs-app1
ssh-keygen -f ~/.ssh/known_hosts -R "10.10.1.5" || true  # multi-app2
ssh-keygen -f ~/.ssh/known_hosts -R "10.10.1.6" || true  # nodejs-app2
ssh-keygen -f ~/.ssh/known_hosts -R "10.10.1.7" || true  # laravel-api

# Run the SSH keyscan playbook to pre-populate known_hosts
echo "Collecting SSH host keys..."
ansible-playbook ssh-keyscan.yml -v

# Test connections first
echo "Testing connectivity to hosts..."
ansible-playbook test-connection.yml

# If connection test succeeds, proceed with deployment
if [ $? -eq 0 ]; then
  # Run the main deployment playbook
  echo "Deploying Apache and PHP..."
  ansible-playbook install-apache.yml -v
  
  # Test connections to verify success
  echo "Testing web servers..."
  ansible webservers -m command -a "curl -s -I http://localhost" | grep "HTTP"
  
  echo "Deployment complete!"
else
  echo "Connection test failed. Please check your SSH configuration and bastion host access."
  exit 1
fi