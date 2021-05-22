#!/bin/bash
# Populate the /tmp/caccounts.txt file
. /etc/sftp_buckets.conf
DYNAMO_DBTABLE_NAME=$(echo $DYNAMO_DBTABLE | cut -f2 -d'/')
#BUCKET_CONFIG=bobbins2-sftp-effective-carnival-latest-config
#BUCKET_DATA=bobbins2-sftp-effective-carnival-latest-data
#aws dynamodb scan --table-name my-table --select ALL_ATTRIBUTES --page-size 500 --max-items 100000 --output json | jq -r '.Items' | jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ].S])[] | @csv' > export.my-table.csv
aws dynamodb scan --table-name ${DYNAMO_DBTABLE_NAME} --region ${AWS_REGION} --select ALL_ATTRIBUTES --page-size 500 --max-items 100000 --output json | jq -r '.Items' | jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ].S])[] | @csv' | sed -e '1d' >/tmp/caccounts_ddb.txt
#aws s3 cp s3://${BUCKET_CONFIG}/caccounts.txt /tmp/caccounts.txt
