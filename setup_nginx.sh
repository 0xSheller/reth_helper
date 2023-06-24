#!/bin/bash

# Install Nginx
sudo apt install nginx -y

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create password file for basic auth (username is 'user')
echo "user:$(openssl passwd -apr1 securepassword)" | sudo tee /etc/nginx/.htpasswd

# Create a configuration file for the prometheus proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/prometheus-proxy
server {
    listen 6006;

    location / {
        proxy_pass http://localhost:9090; # The address of the app you are proxying to
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        # Basic Authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL
'

# Create a configuration file for the reth logs proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/metrics-proxy
server {
    listen 6007;

    location / {
        proxy_pass http://localhost:5005; # The address of the app you are proxying to
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        # Basic Authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL
'

# Create a configuration file for the grafana proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/grafana-proxy
server {
    listen 6008;

    location / {
        proxy_pass http://localhost:3000; # The address of the app you are proxying to
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        # Basic Authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL
'

# Create a configuration file for the siren proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/siren-proxy
server {
    listen 6009;

    location / {
        proxy_pass http://localhost:6969; # The address of the app you are proxying to
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        # Basic Authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL
'

# Create a symbolic link to enable the configuration
sudo ln -s /etc/nginx/sites-available/prometheus-proxy /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/metrics-proxy /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/grafana-proxy /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/siren-proxy /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx
