#!/bin/bash
# Populate the /tmp/caccounts.txt file
. /etc/sftp_buckets.conf
#BUCKET_CONFIG=bobbins2-sftp-effective-carnival-latest-config
#BUCKET_DATA=bobbins2-sftp-effective-carnival-latest-data
aws s3 cp s3://${BUCKET_CONFIG}/caccounts.txt /tmp/caccounts.txt
