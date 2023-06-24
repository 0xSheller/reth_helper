#!/bin/bash

# 1) Update the system
sudo apt-get update

# 2) Upgrade the system
sudo apt-get upgrade -y

# 3) Install AWS CLI
sudo apt-get install awscli -y

# 4) Configure AWS
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
AWS_REGION=""

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set default.region $AWS_REGION

sudo aws configure set aws_access_key_id $AWS_ACCESS_KEY
sudo aws configure set aws_secret_access_key $AWS_SECRET_KEY
sudo aws configure set default.region $AWS_REGION

# 5) Make another script executable
#sudo chmod +x build_archive_node.sh
sudo chmod +x setup_nginx.sh
sudo chmod +x setup_prometheus.sh
sudo chmod +x setup_grafana.sh
sudo chmod +x setup_ufw.sh
sudo chmod +x setup_siren.sh
sudo chmod +x start_lighthouse.sh
sudo chmod +x start_reth.sh

# Make the dirs
sudo mkdir /chain
sudo mkdir /chain/reth
sudo mkdir /chain/reth/data
sudo mv /home/ubuntu/reth_helpers/start_reth.sh /chain/reth/

sudo mkdir /chain/lighthouse
sudo mkdir /chain/lighthouse/data
sudo mv /home/ubuntu/reth_helpers/start_lighthouse.sh /chain/lighthouse/

# 6) Reboot the server
sudo reboot
