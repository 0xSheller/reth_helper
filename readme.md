Just a bunch of scripts to help you get started with reth

.env Example:
```
ARCH="amd64"
NODE_CLIENT="erigon"
BUCKET_NAME="rpc-backups"
BASE_DIR="chain"
NGINX_USER="user"
NGINX_PASS="securepassword"
PROMETHEUS_VERSION="2.45.0"
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
AWS_REGION=""
```

Self-explanatory, you can use the same bucket for both nodes, just make sure you have the correct permissions set up. BASE_DIR is where data will be stored. 

then run in order:
`chmod +x setup_server.sh`

`sudo ./setup_server.sh`

`sudo ./setup_ufw.sh`

`sudo ./setup_nginx.sh`

`sudo ./setup_prometheus.sh`

`sudo ./setup_grafana.sh`

`sudo ./setup_siren.sh`

`sudo ./start_reth.sh` or `sudo ./start_erigon` (nohup / setup as a service / screen)

`sudo ./start_lighthouse.sh`(nohup / setup as a service / screen)

use: https://github.com/paradigmxyz/local_reth/tree/main/grafana/provisioning for dashboard

If you don't plan on taking snapshots of your chaindata, you can remove the snapshot script and the cronjob in setup_server.sh

I will maintain a EBS snapshot of reth at a later point and update these scripts, this is still early but will help others get started.

(I only added erigon"support" because I have a erigon node that took weeks to sync, I would like to keep a backup in case i ever wanna benchmark things in the future)