#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

sudo apt-get install awscli pigz -y

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set default.region $AWS_REGION

sudo aws configure set aws_access_key_id $AWS_ACCESS_KEY
sudo aws configure set aws_secret_access_key $AWS_SECRET_KEY
sudo aws configure set default.region $AWS_REGION