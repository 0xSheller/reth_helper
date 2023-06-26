#!/bin/bash

# Load the environment variables
source load_variables.sh

sudo RUST_LOG=info /$BASE_DIR/$NODE_CLIENT/$NODE_CLIENT node --datadir=/$BASE_DIR/$NODE_CLIENT/data --chain=mainnet --metrics=5005 --port=30303 --http --ws --log.persistent --log.directory=/$BASE_DIR/$NODE_CLIENT/logs/