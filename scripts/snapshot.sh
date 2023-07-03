#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

# Get the current date in the format MMDDYYYY
DATE=$(date +%m%d%Y)

# Set the destination folder path in the bucket
DESTINATION_FOLDER="$NODE_CLIENT/$DATE"

# Set the source folder path in the base directory
SOURCE_FOLDER="/$BASE_DIR/$NODE_CLIENT/data/"

### This whole section can probably be cleaner and more efficient, but it works for now ###

#  Sync the data from the base directory to the destination folder
if [ "$S3_PROVIDER" = "wasabi" ]; then
    # Add the --endpoint-url argument to the aws s3 sync command
    aws s3 sync "${SOURCE_FOLDER}" "s3://${S3_BUCKET_NAME}/${DESTINATION_FOLDER}/" --exclude "jwt.hex" --endpoint-url=https://s3.wasabisys.com
else
    # Run the aws s3 sync command without the --endpoint-url argument
    aws s3 sync "${SOURCE_FOLDER}" "s3://${S3_BUCKET_NAME}/${DESTINATION_FOLDER}/" --exclude "jwt.hex"
fi

# Count the number of directories in the bucket
if [ "$S3_PROVIDER" = "wasabi" ]; then
    # Add the --endpoint-url argument to the aws s3 sync command
    DIR_COUNT=$(aws s3 ls s3://$S3_BUCKET_NAME/$NODE_CLIENT/ --endpoint-url=https://s3.wasabisys.com | grep PRE | wc -l)
else
    # Run the aws s3 rm command without the --endpoint-url argument
    DIR_COUNT=$(aws s3 ls s3://$S3_BUCKET_NAME/$NODE_CLIENT/ | grep PRE | wc -l)
fi


# If there are more than 5 directories, delete the oldest one since we only want to maintain 4 weeks worth of (weekly) snapshots
if [ "$DIR_COUNT" -ge 5 ]; then
  if [ "$S3_PROVIDER" = "wasabi" ]; then
      # Add the --endpoint-url argument to the aws s3 sync command
      OLDEST_DIR=$(aws s3api list-objects --bucket "$S3_BUCKET_NAME" --prefix "$NODE_CLIENT/" --query 'reverse(sort_by(Contents,&LastModified))[0].Key' --output text --endpoint-url=https://s3.wasabisys.com)
      IFS='/' read -ra DIR_PARTS <<< "$OLDEST_DIR"
      OLDEST_PARENT_DIR="${DIR_PARTS[0]}/${DIR_PARTS[1]}"
      aws s3 rm --recursive "s3://$S3_BUCKET_NAME/$OLDEST_PARENT_DIR" --endpoint-url=https://s3.wasabisys.com
  else
      # Run the aws s3 rm command without the --endpoint-url argument
      OLDEST_DIR=$(aws s3api list-objects --bucket "$S3_BUCKET_NAME" --prefix "$NODE_CLIENT/" --query 'reverse(sort_by(Contents,&LastModified))[0].Key' --output text)
      IFS='/' read -ra DIR_PARTS <<< "$OLDEST_DIR"
      OLDEST_PARENT_DIR="${DIR_PARTS[0]}/${DIR_PARTS[1]}"
      aws s3 rm --recursive "s3://$S3_BUCKET_NAME/$OLDEST_DIR"
  fi
fi