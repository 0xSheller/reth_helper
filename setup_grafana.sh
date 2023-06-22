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

# Create a configuration file for the reverse proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/grafana-proxy
server {
    listen 6008;

    location / {
        proxy_pass http://localhost:3000; # The address of the app you are proxying to
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        # Basic Authentication
#        auth_basic "Restricted Content";
#        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL
'

# Create a symbolic link to enable the configuration
sudo ln -s /etc/nginx/sites-available/grafana-proxy /etc/nginx/sites-enabled/

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx

# We need to get current servers ipv4 address
public_ip=$(curl -s https://ipinfo.io/ip)

echo "Grafana is now accessible at http://$public_ip:6008 (admin:admin) (you should probably change this)