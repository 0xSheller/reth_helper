#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ] && [ "${dir_array[2]}" != "scripts" ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

sudo apt-get install awscli pigz -y

# Sometimes AWS CLI wont work without setting on one of these, cba diagnosing why, doesn't hurt to run on both.

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set default.region $AWS_REGION
aws configure set default.s3.max_concurrent_requests 10
aws configure set default.s3.max_queue_size 10000
aws configure set default.s3.multipart_chunksize 200MB

sudo aws configure set aws_access_key_id $AWS_ACCESS_KEY
sudo aws configure set aws_secret_access_key $AWS_SECRET_KEY
sudo aws configure set default.region $AWS_REGION
sudo aws configure set default.s3.max_concurrent_requests 10
sudo aws configure set default.s3.max_queue_size 10000
sudo aws configure set default.s3.multipart_chunksize 200MB


