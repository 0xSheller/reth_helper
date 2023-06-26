#!/bin/bash

# Load the environment variables
source load_variables.sh

sudo apt-get install awscli -y

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set default.region $AWS_REGION

sudo aws configure set aws_access_key_id $AWS_ACCESS_KEY
sudo aws configure set aws_secret_access_key $AWS_SECRET_KEY
sudo aws configure set default.region $AWS_REGION