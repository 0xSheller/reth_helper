Just a bunch of scripts to help you get started with reth

This assumes you have a disk mounted on /chain for an archive node. Might need to change dirs, ill update this to be more interactive in the future when i have time. But it's setup for aarch64/arm64 machines. If you're not using this arch, just change the prometheus URL to reflect whatever arch you're using. 

You can change prometheus version in setup_prometheus.sh

then run in order:
`chmod +x setup_server.sh`
`sudo ./setup_server.sh`
`sudo ./setup_nginx.sh`
`sudo ./setup_prometheus.sh`
`sudo ./start_reth.sh` (nohup / setup as a service / screen)
`sudo ./start_lighthouse.sh`(nohup / setup as a service / screen)

I will maintain a EBS snapshot of reth at a later point and update these scripts, this is still early but will help others get started.