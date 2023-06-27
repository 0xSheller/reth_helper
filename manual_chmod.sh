#!/bin/bash

scripts_directory="$(dirname "$(readlink -f "$0")")"

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
sudo chmod +x "manual_snapshot.sh"