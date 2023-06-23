#!/bin/bash

/chain/lighthouse/lighthouse beacon_node --datadir /chain/lighthouse/data --network mainnet --http --execution-endpoint http://localhost:8551 --execution-jwt /chain/reth/data/jwt.hex --checkpoint-sync-url https://mainnet-checkpoint-sync.stakely.io --disable-backfill-rate-limiting --genesis-backfill