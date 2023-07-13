#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ] && [ "${dir_array[2]}" != "scripts" ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi

# 1) Update the system
sudo apt-get update

# 2) Upgrade the system
sudo apt-get upgrade -y
sudo apt-get install unzip screen -y

# 3) Make another script executable
sudo chmod +x "${parsed_dir}/scripts/finish.sh"
sudo chmod +x "${parsed_dir}/scripts/get_os_arch.sh"
sudo chmod +x "${parsed_dir}/scripts/load_variables.sh"
sudo chmod +x "${parsed_dir}/scripts/restore.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_grafana.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_nginx.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_prometheus.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_s3.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_siren.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_ufw.sh"
sudo chmod +x "${parsed_dir}/scripts/snapshot.sh"
sudo chmod +x "${parsed_dir}/scripts/start_lighthouse.sh"
sudo chmod +x "${parsed_dir}/scripts/start_reth.sh"
sudo chmod +x "${parsed_dir}/scripts/setup_services.sh"
sudo chmod +x "setup_node.sh"

# 4) Load the environment variables
source "${parsed_dir}/scripts/load_variables.sh"

# 5) Source the script that returns OS and CPU architecture variables
source "${parsed_dir}/scripts/get_os_arch.sh"

# 6) Check for compatible CPU Architecture
if [[ "$ARCH_RAW" != "x86_64" && "$ARCH_RAW" != "aarch64" ]]; then
    echo "This server is not compatible with reth unfortunately. Exiting..."
    exit 1
fi

# 7) Check for compatible OS
if [[ "$OS" != "linux" ]]; then
    echo "This server is not on a compatible OS unfortunately. Exiting..."
    exit 1
fi

# 8) Make the dirs
sudo mkdir /$BASE_DIR
sudo mkdir /$BASE_DIR/$NODE_CLIENT
sudo mkdir /$BASE_DIR/$NODE_CLIENT/data

sudo mkdir /$BASE_DIR/lighthouse
sudo mkdir /$BASE_DIR/lighthouse/data

# 9) Grab the right bins for reth
RETH_NAME="reth-v${RETH_VERSION}-alpha.1-${ARCH_RAW}-unknown-linux-gnu.tar.gz"
RETH_URL="https://github.com/paradigmxyz/reth/releases/download/v${RETH_VERSION}-alpha.3/${RETH_NAME}"
echo "Downloading reth from ${RETH_URL}"
curl -LOs ${RETH_URL}
tar -xzf ${RETH_NAME} -C /$BASE_DIR/$NODE_CLIENT/
rm ${RETH_NAME}

# 10) Grab the right bins for lighthouse
LIGHTHOUSE_NAME="lighthouse-v${LIGHTHOUSE_VERSION}-${ARCH_RAW}-unknown-linux-gnu-portable.tar.gz"
LIGHTHOUSE_URL="https://github.com/sigp/lighthouse/releases/download/v${LIGHTHOUSE_VERSION}/${LIGHTHOUSE_NAME}"
echo "Downloading lighthouse from ${LIGHTHOUSE_URL}"
curl -LOs ${LIGHTHOUSE_URL}
tar -xzf ${LIGHTHOUSE_NAME} -C /$BASE_DIR/lighthouse/
rm ${LIGHTHOUSE_NAME}

# 11) Add a cron job entry for automated snapshots
if [[ "$SNAPSHOT" == "true" ]]; then
    (crontab -l ; echo "0 0 * * 1 /bin/bash ${parsed_dir}/scripts/snapshot.sh") | crontab -
    echo "Chron job added for snapshotting."
fi

# 12) Reboot the server
echo "Rebooting the server in 5s..."
sleep 5
sudo reboot
