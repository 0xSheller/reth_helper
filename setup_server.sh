#!/bin/bash

# 1) Update the system
sudo apt-get update

# 2) Upgrade the system
sudo apt-get upgrade -y

# 3) Make another script executable
sudo chmod +x setup_nginx.sh
sudo chmod +x setup_prometheus.sh
sudo chmod +x setup_grafana.sh
sudo chmod +x setup_ufw.sh
sudo chmod +x setup_siren.sh
sudo chmod +x start_lighthouse.sh
sudo chmod +x start_reth.sh
sudo chmod +x start_wasabi.sh

# 4) Make the dirs
sudo mkdir /chain
sudo mkdir /chain/reth
sudo mkdir /chain/reth/data
sudo mv /home/ubuntu/reth_helpers/start_reth.sh /chain/reth/

sudo mkdir /chain/lighthouse
sudo mkdir /chain/lighthouse/data
sudo mv /home/ubuntu/reth_helpers/start_lighthouse.sh /chain/lighthouse/

# 5) Reboot the server
sudo reboot
