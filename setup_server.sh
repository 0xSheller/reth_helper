#!/bin/bash

scripts_directory="$(dirname "$(readlink -f "$0")")"

# 1) Update the system
sudo apt-get update

# 2) Upgrade the system
sudo apt-get upgrade -y

# 3) Make another script executable
sudo chmod +x "${scripts_directory}/scripts/finish.sh"
sudo chmod +x "${scripts_directory}/scripts/get_os_arch.sh"
sudo chmod +x "${scripts_directory}/scripts/load_variables.sh"
sudo chmod +x "${scripts_directory}/scripts/restore.sh"
sudo chmod +x "${scripts_directory}/scripts/setup_grafana.sh"
sudo chmod +x "${scripts_directory}/scripts/setup_nginx.sh"
sudo chmod +x "${scripts_directory}/scripts/setup_prometheus.sh"
sudo chmod +x "${scripts_directory}/scripts/setup_s3.sh"
sudo chmod +x "${scripts_directory}/scripts/setup_siren.sh"
sudo chmod +x "${scripts_directory}/scripts/setup_ufw.sh"
sudo chmod +x "${scripts_directory}/scripts/snapshot.sh"
sudo chmod +x "${scripts_directory}/scripts/start_lighthouse.sh"
sudo chmod +x "${scripts_directory}/scripts/start_reth.sh"
sudo chmod +x "setup_node.sh"

# 4) Load the environment variables
source "${scripts_directory}/scripts/load_variables.sh"

# 5) Source the script that returns OS and CPU architecture variables
source "${scripts_directory}/scripts/get_os_arch.sh"

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

# 9) Grab the right bins for lighthouse and reth
curl -Ls "https://github.com/paradigmxyz/reth/releases/download/v${RETH_VERSION}-alpha.1/reth-v${RETH_VERSION}-alpha.1-${ARCH_RAW}-unknown-linux-gnu.tar.gz" | tar -xzf - -C /$BASE_DIR/$NODE_CLIENT
curl -Ls "https://github.com/sigp/lighthouse/releases/download/v${LIGHTHOUSE_VERSION}/lighthouse-v${LIGHTHOUSE_VERSION}-${ARCH_RAW}-unknown-linux-gnu-portable.tar.gz" | tar -xzf - -C /$BASE_DIR/lighthouse

# 10) Add a cron job entry for automated snapshots
if [[ "$SNAPSHOT" == "true" ]]; then
    (crontab -l ; echo "0 0 * * 0 /bin/bash ${scripts_directory}/scripts/snapshot.sh") | crontab -
    echo "Chron job added for snapshotting."
fi

# 11) Reboot the server
echo "Rebooting the server in 5s..."
sleep 5
sudo reboot
