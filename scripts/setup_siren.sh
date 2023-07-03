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

# Update package information
sudo apt-get update

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common unzip

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker APT repository
sudo add-apt-repository "deb [arch=$SERVER_ARCH] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package database with Docker packages
sudo apt-get update

# Install Docker
sudo apt-get install -y docker-ce

# Download Siren
curl -LO https://github.com/sigp/siren/archive/refs/tags/v0.1.0-beta.4.tar.gz

# Unzip Siren
tar xvfz "v0.1.0-beta.4.tar.gz"

# Go to Siren directory
cd siren-0.1.0-beta.4

# Assuming there's a Dockerfile, build the Docker image
sudo make docker

# Run Siren in a Docker container
sudo docker run --rm -ti -d --name siren -p 6969:80 siren -d

