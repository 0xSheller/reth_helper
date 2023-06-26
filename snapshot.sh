#!/bin/bash

# Load the environment variables
source load_variables.sh

# Get the current date in the format MMDDYYYY
DATE=$(date +%m%d%Y)

# Set the destination folder path in the bucket
DESTINATION_FOLDER="$NODE_CLIENT/$DATE"

# Set the source folder path in the base directory
SOURCE_FOLDER="$BASE_DIR/$NODE_CLIENT/data"

# Sync the data from the base directory to the destination folder
aws s3 sync "$SOURCE_FOLDER" "s3://$BUCKET_NAME/$DESTINATION_FOLDER" --endpoint-url=https://s3.wasabisys.com

# 0 0 * * 0 /bin/bash ~/reth_helpers/snapshot.sh
