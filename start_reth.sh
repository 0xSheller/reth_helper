#!/bin/bash

# Load the environment variables
source load_variables.sh

RUST_LOG=info /$BASE_DIR/reth/reth node --datadir=/$BASE_DIR/reth/data --chain=mainnet --metrics=5005 --port=30303 --http --ws --log.persistent --log.directory=/$BASE_DIR/reth/logs/