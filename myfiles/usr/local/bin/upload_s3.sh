#!/bin/bash
. /etc/sftp_buckets.conf
#BUCKET_CONFIG=bobbins2-sftp-effective-carnival-latest-config
#BUCKET_DATA=bobbins2-sftp-effective-carnival-latest-data
for user in $(/bin/grep "Automatic sftp user" /etc/passwd | cut -f1 -d':' )
  do
     aws s3 cp /home/${user}/uploads/uploads/* s3://${BUCKET_DATA}/${user}/
  done
