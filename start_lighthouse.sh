#!/bin/bash

# Load the environment variables
source load_variables.sh

/$BASE_DIR/lighthouse/lighthouse beacon_node --datadir /$BASE_DIR/lighthouse/data --network mainnet --http --execution-endpoint http://localhost:8551 --execution-jwt /$BASE_DIR/$NODE_CLIENT/data/jwt.hex --checkpoint-sync-url https://mainnet-checkpoint-sync.stakely.io --disable-backfill-rate-limiting --genesis-backfill --disable-deposit-contract-sync --execution-timeout-multiplier 10
