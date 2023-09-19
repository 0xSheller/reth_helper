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
sudo ufw allow 9001/tcp
sudo ufw allow 9001/udp
sudo ufw allow 9001/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9001 proto tcp
sudo ufw allow 9001/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9001 proto udp
sudo ufw allow 9001/tcp6
sudo ufw allow 9001/udp6

# Allow traffic on 9000  for TCP on IPv4 and IPv6 (Lighthouse) UGLY but i CBA going thru this rn if it works it aint broke
sudo ufw allow 9909/tcp
sudo ufw allow 9909/udp
sudo ufw allow 9909/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9909 proto tcp
sudo ufw allow 9909/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9909 proto udp
sudo ufw allow 9909/tcp6
sudo ufw allow 9909/udp6
sudo ufw allow 9000/tcp
sudo ufw allow 9000/udp
sudo ufw allow 9000/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9000 proto tcp
sudo ufw allow 9000/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9000 proto udp
sudo ufw allow 9000/tcp6
sudo ufw allow 9000/udp6
sudo ufw allow 9999/tcp
sudo ufw allow 9999/udp
sudo ufw allow 9999/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9999 proto tcp
sudo ufw allow 9999/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9999 proto udp
sudo ufw allow 9999/tcp6
sudo ufw allow 9999/udp6
sudo ufw allow 9090/tcp
sudo ufw allow 9090/udp
sudo ufw allow 9090/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9090 proto tcp
sudo ufw allow 9090/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9090 proto udp
sudo ufw allow 9090/tcp6
sudo ufw allow 9090/udp6
sudo ufw allow 9090/tcp
sudo ufw allow 9090/udp
sudo ufw allow 9090/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9090 proto tcp
sudo ufw allow 9090/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9090 proto udp
sudo ufw allow 9090/tcp6
sudo ufw allow 9090/udp6
sudo ufw allow 9911/tcp
sudo ufw allow 9911/udp
sudo ufw allow 9911/tcp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9911 proto tcp
sudo ufw allow 9911/udp comment 'Lighthouse beacon node' && sudo ufw allow from any to any port 9911 proto udp
sudo ufw allow 9911/tcp6
sudo ufw allow 9911/udp6


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
