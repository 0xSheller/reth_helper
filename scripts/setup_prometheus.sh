#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

# Download Prometheus
wget "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}.tar.gz"
echo "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}.tar.gz"

# Extract the downloaded file
tar xvfz "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}.tar.gz"

# Move Prometheus and configuration files to /usr/local/bin
sudo mv "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}/prometheus" /usr/local/bin/
sudo mv "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}/promtool" /usr/local/bin/

# Move consoles and console_libraries directories to /etc/prometheus
sudo mkdir -p /etc/prometheus
sudo mv "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}/consoles" /etc/prometheus
sudo mv "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}/console_libraries" /etc/prometheus

# Move prometheus.yml to /etc/prometheus and add the target localhost:5005
sudo mv "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}/prometheus.yml" /etc/prometheus
echo "  - job_name: 'localhost'
    static_configs:
    - targets: ['localhost:5005']
" | sudo tee -a /etc/prometheus/prometheus.yml

# Clean up the downloaded files
rm -rf "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}"
rm "prometheus-${PROMETHEUS_VERSION}.${OS}-${ARCH}.tar.gz"

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
