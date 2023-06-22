#!/bin/bash

# Set version number (check for the latest version on the Prometheus website)
PROMETHEUS_VERSION="2.44.0"

# Download Prometheus
wget "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-arm64.tar.gz"

# Extract the downloaded file
tar xvfz "prometheus-${PROMETHEUS_VERSION}.linux-arm64.tar.gz"

# Move Prometheus and configuration files to /usr/local/bin
sudo mv "prometheus-${PROMETHEUS_VERSION}.linux-arm64/prometheus" /usr/local/bin/
sudo mv "prometheus-${PROMETHEUS_VERSION}.linux-arm64/promtool" /usr/local/bin/

# Move consoles and console_libraries directories to /etc/prometheus
sudo mkdir -p /etc/prometheus
sudo mv "prometheus-${PROMETHEUS_VERSION}.linux-arm64/consoles" /etc/prometheus
sudo mv "prometheus-${PROMETHEUS_VERSION}.linux-arm64/console_libraries" /etc/prometheus

# Move prometheus.yml to /etc/prometheus and add the target localhost:5005
sudo mv "prometheus-${PROMETHEUS_VERSION}.linux-arm64/prometheus.yml" /etc/prometheus
echo "  - job_name: 'localhost'
    static_configs:
    - targets: ['localhost:5005']
" | sudo tee -a /etc/prometheus/prometheus.yml

# Clean up the downloaded files
rm -rf "prometheus-${PROMETHEUS_VERSION}.linux-arm64"
rm "prometheus-${PROMETHEUS_VERSION}.linux-arm64.tar.gz"

# Create a systemd service file for Prometheus
sudo bash -c 'cat << EOL > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOL
'

# Create data directory for Prometheus
sudo mkdir -p /var/lib/prometheus

# Reload systemd, enable and start Prometheus service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# We need to get current servers ipv4 address
public_ip=$(curl -s https://ipinfo.io/ip)

echo "Prometheus is now accessible at http://$public_ip:6006 (Metrics accessible at http://$public_ip:6007 for whatever reason if you need that)"