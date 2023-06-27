#!/bin/bash

# Install UFW
sudo apt-get update
sudo apt-get install -y ufw

# Enable UFW
sudo ufw --force enable

# Allow port 22 because we need SSH and i already locked myself out accidently FML
sudo ufw allow 22

# Allow traffic on port 42069 for TCP and UDP on both IPv4 and IPv6
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp

# Allow traffic on 9000  for TCP on IPv4 and IPv6 (Lighthouse)
sudo ufw allow 9000/tcp
sudo ufw allow 9000/udp

# Allow traffic on port 6006, 6007, 6008 for TCP on IPv4
sudo ufw allow 6006/tcp
sudo ufw allow 6007/tcp
sudo ufw allow 6008/tcp
sudo ufw allow 6009/tcp

# Allow traffic on port 69, 96 for TCP on IPv4
sudo ufw allow 69/tcp
sudo ufw allow 96/tcp

# Reload UFW to apply the changes
sudo ufw reload

# Display the UFW status
sudo ufw status verbose
