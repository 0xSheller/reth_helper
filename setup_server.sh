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
sudo chmod +x status.sh
sudo chmod +x setup_nginx.sh
sudo chmod +x install_promethus.sh

# 6) Reboot the server
sudo reboot
