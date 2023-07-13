#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ] && [ "${dir_array[2]}" != "scripts" ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

## TODO: pull the most recent snapshot date from the bucket, possibly some kind of .json or something that the snapshot.sh script writes to when it runs, because current implementation assumes that snapshots will be maintained indefinitely

# last_snapshot variable should be the most recent monday midnight date based on our chron schedule
#RECENT_SNAPSHOT=$(date -d "last monday 00:00" +%m%d%Y)

# Hardcoded because can't snapshot while node is live, need to figure it out later don't have time right now.
RECENT_SNAPSHOT="06262023"

# Set the destination folder path in the bucket
DESTINATION_FOLDER="/$BASE_DIR/$NODE_CLIENT/data/"

if [ "$S3_PROVIDER" = "wasabi" ]; then
    # Add the --endpoint-url argument to the aws s3 sync command
    aws s3 sync "s3://$S3_BUCKET_NAME/$NODE_CLIENT/$RECENT_SNAPSHOT/" "$DESTINATION_FOLDER" --endpoint-url=https://s3.wasabisys.com --no-sign-request
else
    # Run the aws s3 sync command without the --endpoint-url argument
    aws s3 sync "s3://$S3_BUCKET_NAME/$NODE_CLIENT/$RECENT_SNAPSHOT/" "$DESTINATION_FOLDER" --no-sign-request
fi
