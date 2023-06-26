#!/bin/bash

# Load the environment variables
source load_variables.sh

# Set the base directory path
BASE_DIR=$

# Get the current date in the format MMDDYYYY
DATE=$(date +%m%d%Y)

# Set the destination folder path in the bucket
DESTINATION_FOLDER="$NODE_CLIENT/$DATE"

# Create the destination folder in the bucket
aws s3 mkdir "s3://$BUCKET_NAME/$DESTINATION_FOLDER" --endpoint-url=https://s3.wasabisys.com

# Sync the data from the base directory to the destination folder
aws s3 sync "$BASE_DIR" "s3://$BUCKET_NAME/$DESTINATION_FOLDER" --endpoint-url=https://s3.wasabisys.com

# 0 0 * * 0 /bin/bash ~/reth_helpers/snapshot.sh
