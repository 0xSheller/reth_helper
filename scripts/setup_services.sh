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

# Create systemd service for start_reth.sh
cat << EOF | sudo tee /etc/systemd/system/reth.service
[Unit]
Description=rETH Service
After=network.target network-online.target
Wants=network-online.target

[Service]
User=$USER
ExecStart=/bin/bash $CURRENT_DIRECTORY/scripts/start_reth.sh
Restart=always
RestartSec=30s

# Output to syslog
StandardOutput=syslog
StandardError=syslog

#Change this to find app logs in /var/log/syslog
SyslogIdentifier=reth

[Install]
WantedBy=multi-user.target
EOF

# Create systemd service for start_lighthouse.sh
cat << EOF | sudo tee /etc/systemd/system/lighthouse.service
[Unit]
Description=Lighthouse Service
After=network.target network-online.target
Wants=network-online.target

[Service]
User=$USER
ExecStart=/bin/bash $CURRENT_DIRECTORY/scripts/start_lighthouse.sh
Restart=always
RestartSec=30s

# Output to syslog
StandardOutput=syslog
StandardError=syslog

#Change this to find app logs in /var/log/syslog
SyslogIdentifier=lighthouse

[Install]
WantedBy=multi-user.target
EOF


# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start the reth service
sudo systemctl enable reth.service
sudo systemctl start reth.service

# Enable and start the lighthouse services
sudo systemctl enable lighthouse.service
sudo systemctl start lighthouse.service

