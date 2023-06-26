#!/bin/bash

# Load the environment variables
source load_variables.sh

## TODO: pull the most recent snapshot date from the bucket, possibly some kind of .json or something that the snapshot.sh script writes to when it runs, because current implementation assumes that snapshots will be maintained indefinitely

# last_snapshot variable should be the most recent sunday midnight date based on our chron schedule
RECENT_SNAPSHOT=$(date -d "last sunday 00:00" +%m%d%Y)

# Set the destination folder path in the bucket
DESTINATION_FOLDER="$BASE_DIR/$NODE_CLIENT/data"

# Sync the data from the base directory to the destination folder
aws s3 sync "s3://$BUCKET_NAME/$NODE_CLIENT/$RECENT_SNAPSHOT" "$DESTINATION_FOLDER" --endpoint-url=https://s3.wasabisys.com
