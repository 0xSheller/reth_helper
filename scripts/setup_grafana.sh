#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

# Add Grafana's APT repository
sudo apt-get install -y software-properties-common
yes | sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Add Grafana's GPG key to ensure packages' integrity
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Update APT cache
sudo apt-get update

# Install Grafana
sudo apt-get install grafana -y

# Enable and start the Grafana service using systemd
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Wait for Grafana to start
echo "Waiting on Grafana to start..."
sleep 10

# Add the datasource
curl -X "POST" "http://admin:admin@localhost:3000/api/datasources" \
     -H "Content-Type: application/json" \
     --data-binary "@${parsed_dir}/scripts/grafana_dashboard/reth.yml"

# Add the dashboard
DASHBOARD_JSON=$(cat "${parsed_dir}/scripts/grafana_dashboard/reth.json")
DATA="{\"dashboard\":$DASHBOARD_JSON,\"overwrite\":true, \"folderId\": 0}"
curl -X "POST" "http://admin:admin@localhost:3000/api/dashboards/db" \
     -H "Content-Type: application/json" \
     -d "$DATA"
