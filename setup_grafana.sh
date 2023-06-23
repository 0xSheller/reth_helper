#!/bin/bash

# Add Grafana's APT repository
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Add Grafana's GPG key to ensure packages' integrity
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Update APT cache
sudo apt-get update

# Install Grafana
sudo apt-get install grafana -y

# Enable and start the Grafana service using systemd
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# We need to get current servers ipv4 address
public_ip=$(curl -s https://ipinfo.io/ip)

# Wait for Grafana to start
echo "Waiting on Grafana to start..."
sleep 10

# Add the datasource
curl -X "POST" "http://admin:admin@localhost:3000/api/datasources" \
     -H "Content-Type: application/json" \
     --data-binary "@grafana_dashboard/reth.yml"

# Add the dashboard
DASHBOARD_JSON=$(cat grafana_dashboard/reth.json)
DATA="{\"dashboard\":$DASHBOARD_JSON,\"overwrite\":true, \"folderId\": 0}"
curl -X "POST" "http://admin:admin@localhost:3000/api/dashboards/db" \
     -H "Content-Type: application/json" \
     -d "$DATA"

# Echo the URL
echo "Grafana is now accessible at http://$public_ip:6008 (admin:admin) (you should probably change this)"
