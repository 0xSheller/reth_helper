#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

# Install Nginx
sudo apt install nginx -y

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create password file for basic auth (username is 'user')
echo "$NGINX_USER:$(openssl passwd -apr1 $NGINX_PASS)" | sudo tee /etc/nginx/.htpasswd

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
        #auth_basic "Restricted Content";
        #auth_basic_user_file /etc/nginx/.htpasswd;
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

# Create a configuration file for the RPC HTTP proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/rpc-http-proxy
server {
    listen 69;

    location / {
        proxy_pass http://localhost:8545; # The address of the app you are proxying to
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;

        # Basic Authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
EOL
'

# Create a configuration file for the RPC WS proxy
sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/rpc-ws-proxy
server {
    listen 96;

    location / {
        proxy_pass http://localhost:8546; # The address of the app you are proxying to
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
sudo ln -s /etc/nginx/sites-available/rpc-http-proxy /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/rpc-ws-proxy /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx
