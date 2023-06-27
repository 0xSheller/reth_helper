#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

sudo /$BASE_DIR/lighthouse/lighthouse beacon_node --datadir /$BASE_DIR/lighthouse/data --network mainnet --http --execution-endpoint http://localhost:8551 --execution-jwt /$BASE_DIR/$NODE_CLIENT/data/jwt.hex --checkpoint-sync-url https://mainnet-checkpoint-sync.stakely.io --disable-backfill-rate-limiting --genesis-backfill --disable-deposit-contract-sync --execution-timeout-multiplier 10
