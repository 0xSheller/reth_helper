#!/bin/bash

RUST_LOG=info /chain/reth node --datadir=/chain/reth_data --chain=mainnet --metrics=5005 --port=30303 --http --ws --log.persistent --log.directory=/chain/logs/reth/