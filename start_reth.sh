#!/bin/bash

RUST_LOG=info /chain/reth/reth node --datadir=/chain/reth/data --chain=mainnet --metrics=5005 --port=30303 --http --ws --log.persistent --log.directory=/chain/reth/logs/