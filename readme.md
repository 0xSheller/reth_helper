# rETH Instant Deploys

Unfortunately there's been such a high demand on this that my Wasabi egress was simply too expensive for Wasabi and they shut off public access on my repos. Working on transfering over to S3 when i have some free time. You can still use this repo, just set `SYNC_FROM` to `chain` sync rather than `s3`.

## Description

This project provides a comprehensive set of scripts to facilitate the  setup and management of reth, allowing you to quickly create and maintain Ethereum archive nodes. Whether you prefer utilizing pre-existing S3 bucket snapshots or manually syncing your node, this project has you covered.

The scripts automate several key tasks to ensure a smooth and secure setup:

- Automatic instant fully sync'd [reth](https://github.com/paradigmxyz/reth) archive nodes (via my publicly available and maintained S3 bucket on [wasabi](https://wasabi.com/) - or setup your own!)
- Automatic provisioning of server security measures, including firewall configuration and authenticated reverse proxies via nginx, to protect your infrastructure from unauthorized access.
- Automated creation and maintenance of weekly snapshots for your nodes, providing data redundancy, easy frustration-free scalability, and recovery options.
- Automatically sets up [Prometheus](https://github.com/prometheus/prometheus) for monitoring and observability purposes
- Automatically sets up [Grafana](https://github.com/grafana/grafana) with an imported [rETH dashboard](https://github.com/paradigmxyz/local_reth/tree/main/grafana/provisioning), providing visualizations and insights into your Ethereum archive node.
- Automatically sets up [Lighthouse](https://github.com/sigp/lighthouse), enabling you to contribute (and/or follow) the Ethereum network and validate blockchain transactions.
- Automatically sets up [Siren](https://github.com/sigp/siren), a powerful user interface the your Validator.

## Why?

We extract **A LOT** of data over at [Rinzo](https://www.twitter.com/rinzo). No RPC provider could handle our load without asking for 15-50k a month. 

Redundancy and speed concerns also came to mind, we've been exploring solutions to host our own infrastructure as we gear closer to launch. This is the result of that exploration. 

We still maintain a private erigon archive node for our own purposes (redundancy sake as well), but we've found reth to be reliable and stable (far more than erigon) in just under 24h of playing with it. It's that good. We've also found that it's much easier to maintain and update.

You can spin up a load balancer, and a cluster of RPC's to handle massive amounts of requests for a fraction of the cost of a single provider. For example, you can host this entire script on $50-$100 a month (on a budget) machine, do without the rate limiting, and achieve higher speeds than going through an RPC provider.

### Why Reth?

reth is a very well put together implementation of the ethereum protocol released by paradigm. Although it was just launched and in alpha, (**IMO**) trumps every other implementation out there.

reth takes the best from every other implementation, and combines it into one. Which leaves you with an extremely fast, modular, and reliable implementation. All things everyone in the space wants.

Pros:
- Extremely fast (written in rust 🤪)
- Modular
- Syncs in 50-75 hours (compared to 2-3 weeks for other implementations)
- Resource efficient
- Uses erigons stages sync architecture, however they've made the process a lot faster, and stable (based on my n=1 sample).
- Entire archive node is less than 2TB (compared to 3-30TB for other implementations)
- Actually documented...

Cons:
- Still in alpha

## Setup

_This script was tested on ubuntu 22.04 on both aarch64 and x86_64. These are the only two supported architecture types by reth. If they add support for others, I will update the script to support them._

Before running the scripts, ensure that you have set up your environment variables in the `.env` file. Here is an example:

```
NODE_CLIENT="reth"
SNAPSHOT="false"
SYNC_FROM="public"
BASE_DIR="chain"
NGINX_USER="user"
NGINX_PASS="password"
RETH_VERSION="0.1.0-alpha.1"
LIGHTHOUSE_VERSION="4.2.0"
PROMETHEUS_VERSION="2.45.0"
S3_PROVIDER="wasabi"
S3_BUCKET_NAME="some_bucket"
AWS_ACCESS_KEY="key"
AWS_SECRET_KEY="secret"
AWS_REGION="us-east-1"
```

The project utilizes the following environment variables, each serving a specific purpose:

- `NODE_CLIENT` (*optional*): Specifies the client to be used. Please ensure that you set this variable to the desired value. Example: `NODE_CLIENT="reth"`. This is leftover from my final snapshot of [erigon](https://github.com/ledgerwatch/erigon) in favor of reth. It will be depreciated in future releases. (defaults to `reth`)
- `SNAPSHOT` (*optional*): `true|false` Indicates whether you'd like to create automated backups of your server. Set this variable to either "true" or "false" based on your preference. (defaults to `false`)
- `SYNC_FROM` (*optional*): `public|private|chain` Indicates whether you'd like to download chain data from S3 or sync your node on-chain. `public` will use my personally maintained reth archive node snapshot (30-90 minutes), `private` will attempt use your own snapshots from specified S3 bucket (note: **it must've been done via this script**) (30-90 minutes), `chain` will sync the node traditionally (about 50-75 hours). (defaults to `chain`)
- `BASE_DIR` (*optional*): Specifies the directory where the data will be stored. Example: `BASE_DIR="chain"`. (defaults to `chain`)
- `NGINX_USER` (*optional*): Sets the username for Nginx authentication. Example: `NGINX_USER="user"`.
- `NGINX_PASS` (*optional*): Sets the password for Nginx authentication. Example: `NGINX_PASS="securepassword"`.
- `RETH_VERSION` (*optional*): Specifies the version of rETH to be installed. If you have a specific version requirement, set this variable to the desired version. Example: `RETH_VERSION="0.1.0-alpha.8"`. (defaults to `0.1.0-alpha.1`).
- `LIGHTHOUSE_VERSION` (*optional*): Specifies the version of Lighthouse to be installed. If you have a specific version requirement, set this variable to the desired version. Example: `LIGHTHOUSE_VERSION="4.2.0"`. (defaults to `4.2.0`).
- `PROMETHEUS_VERSION` (*optional*): Specifies the version of Prometheus to be installed. If you have a specific version requirement, set this variable to the desired version. Example: `PROMETHEUS_VERSION="2.45.0"`. (defaults to `2.45.0`).
- `S3_PROVIDER` (*optional*): (`wasabi|aws`) Specifies the s3 provider. If you choose to use snapshots, set this variable accordingly. Example: `S3_PROVIDER="wasabi"`. This variable is only applicable if `SNAPSHOT` is set to "true".
- `S3_BUCKET_NAME` (*optional*): Specifies the name of the S3 bucket for storing & retrieving snapshots. If you choose to use snapshots, set this variable accordingly. Example: `BUCKET_NAME="rpc-backups"`. This variable is only applicable if `SNAPSHOT` is set to "true".
- `AWS_ACCESS_KEY` (*optional*): Sets the AWS access key for snapshot-related operations. If you are using AWS services and need to provide access credentials, set this variable to the appropriate access key. Example: `AWS_ACCESS_KEY="your-access-key"`. If left empty, the script will assume no AWS access key is required.
- `AWS_SECRET_KEY` (*optional*): Sets the AWS secret key for snapshot-related operations. If you provided an access key, set the corresponding secret key here. Example: `AWS_SECRET_KEY="your-secret-key"`. This variable is only applicable if `AWS_ACCESS_KEY` is set.
- `AWS_REGION` (*optional*): Specifies the AWS region for snapshot-related operations. If you provided access credentials and need to specify a region, set this variable accordingly. Example: `AWS_REGION="us-west-2"`. This variable is only applicable if `AWS_ACCESS_KEY` is set.

Please note that the mandatory environment variables must be correctly set for the project to function properly. The optional variables can be left empty if you do not require their corresponding functionality.

#### My Maintained Snapshots
My publicly available (anyone can download) snapshots are available on the Wasabi S3 service, on the bucket named `rpc`.

If you'd like to use my publicly accessible images to get a fully sync'd archive node in 30-90 minutes, you can do the following:
1) set `SYNC_FROM` to `public`
2) set `S3_PROVIDER` to `wasabi`
3) set `S3_BUCKET_NAME` to `rpc`

Snapshots are automatically uploaded to this bucket every 7 days.

## Installation Steps

Follow these steps in the given order to set up the project:
1. Download the script
```Bash
curl -LO https://github.com/0xSheller/reth_helper/archive/refs/heads/main.zip && unzip main.zip && mv reth_helper-main reth_helper
```

2. Setup your .env

3. Run the following command to grant execute permissions to the setup_server.sh script:

```Bash
chmod +x setup_server.sh
```

4. Execute the setup_server.sh script with administrative privileges:

```Bash
sudo ./setup_server.sh
```

5. After reboot, Run the run.sh script as root:

```Bash
sudo ./setup_node.sh
```

#### and you're done!

checkout the `setup_summary.txt` for all endpoints, and credentials. 

## Known Bugs

Added this section because I can't dedicate much more time to this, Need to focus on other things. When i have time in the future i will fix these bugs, but here's a list of known bugs:

1. Grafana dashboard doesn't display correct data

This is because sometimes during import, the json gets messed up. Not sure why, but to fix this head over to datasources, edit the prometheus data source, and set it to "http://localhost:9090" and save. This should fix the issue.

2. The services don't start

This is because i'm assuming you changed the project layout, this is a easy fix, simply run: 
```Bash
sudo nano /etc/systemd/system/reth.service
```

AND

```Bash
sudo nano /etc/systemd/system/reth.service
```

and change the `WorkingDirectory` to the correct path. IE: `ExecStart=/bin/bash /home/ubuntu/reth_helper/scripts/start_lighthouse.sh` and `ExecStart=/bin/bash /home/ubuntu/reth_helper/scripts/start_reth.sh`

## Support
Thank you for using this project. Your feedback and contributions are appreciated.

I designed the snapshot mechanism to only retain 4 active snapshots, which is around ~10TB or $718 a year. The server is around ~$500 a month. In Total that's ~$6500 a year (ill probably downsize this instance to something really tiny to save money and indefinitely maintain snapshots)

It'd be nice to not have to pay for this out of pocket for the foreseeable future, so if you found value in this repo, feel free to send a dollar or two to my ETH address `0x4286a468f267343f611Ee5057059522Dc922eAAD`

Especially big thank you to:
| Contributor                                     | Contribution                                                                                          |
|--------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| [0xSheller](https://github.com/0xSheller)        | Love and support for the project (I love myself)                                                                       |
| [Paradigm](https://github.com/paradigmxyz)       | Assembling one of the best Ethereum protocol implementations                                          |
| [Gui @ Latitude](https://latitude.sh)            | Generously providing $200 in credits for the development of this project                             |

In this table, we express our gratitude to the contributors for their various contributions to the project.
