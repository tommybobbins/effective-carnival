#!/bin/bash
for user in $(/bin/grep "Automatic sftp user" /etc/passwd | cut -f1 -d':' )
  do
#     ls /home/${user}/uploads/uploads/
#     rsync -av "/home/${user}/uploads/uploads/" /tmp/${user}/
     aws s3 sync /home/${user}/uploads/uploads/* s3://tommybobbins/${user}
#    s3cmd
  done
