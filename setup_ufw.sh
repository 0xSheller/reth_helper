#!/bin/bash

# Install UFW
sudo apt-get update
sudo apt-get install -y ufw

# Enable UFW
sudo ufw enable

# Allow traffic on port 42069 for TCP and UDP on both IPv4 and IPv6
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp
sudo ufw allow proto tcp from any to any port 30303 ip6
sudo ufw allow proto udp from any to any port 30303 ip6

# Allow traffic on port 6006, 6007, 6008 for TCP on IPv4
sudo ufw allow 6006/tcp
sudo ufw allow 6007/tcp
sudo ufw allow 6008/tcp

# Reload UFW to apply the changes
sudo ufw reload

# Display the UFW status
sudo ufw status verbose
