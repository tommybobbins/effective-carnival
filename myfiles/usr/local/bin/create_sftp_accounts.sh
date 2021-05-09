#!/bin/bash
# For a text file, import with username/password/private key
# Should be really done with AWS parameter store or Dynamo DB, but no time.
# /tmp/caccounts.txt should look similar to the following - remove the leading hash
#username|password|ssh-key
#foo1||ssh-rsa AAAAB3NzaC1yc2EAAA.......continues......mHG1HZeE= tng@jake
#foo3|bobbins|
#foo1 will have an account created using the public key
#foo3 will have an account created using the username/password
# sshd-config will contain the following
#Match group sftpusers
#    AllowUsers *
#    X11Forwarding no
#    AllowTcpForwarding no
#    ChrootDirectory %h/uploads
#    ForceCommand internal-sftp
#    AuthorizedKeysFile /etc/ssh-pool/%u.pub



addsftpuser () {
    echo $1
    USER=$1
    echo "$USER"
    useradd -g sftpusers -c "Automatic sftp user ${USER}" -s /sbin/nologin ${USER}
    mkdir -p /home/${USER}/.ssh
    chown root:sftpusers /home/${USER}
    mkdir -p /home/${USER}/uploads/uploads
    chmod 700 /home/${USER}
    chown ${USER}:sftpusers /home/${USER}/uploads/uploads
    chmod -R 755 /home/${USER}/uploads
}

IMPORT_FILE="/tmp/caccounts.txt"
IMPORT_FILE_PREV="/tmp/caccounts.txt.prev"
FLOCK_FILE="/tmp/caccounts.lock"

{

    diff $IMPORT_FILE $IMPORT_FILE_PREV
    if [ $? -eq 0 ]
    then
       echo "There is nothing to do. Exiting"
       rm $FLOCK_FILE
       exit
    fi
    # exit if we are unable to obtain a lock; this would happen if 
    # the script is already running elsewhere
    flock -x -n 100 || exit
    while read line
    do
      echo "##############"
      echo "$line"
      USERNAME=$( echo $line | cut -f1 -d'|' )
      PASSWORD=$( echo $line | cut -f2 -d'|' )
      SSH_KEY=$( echo $line | cut -f3 -d'|' )
      echo "user = $USERNAME, password = $PASSWORD, ssh_key = $SSH_KEY"
      id ${USERNAME}
      USER_EXISTS=$?
      if [ "${USER_EXISTS}" -eq 0 ]
      then
         echo "User $USERNAME already exists. Continue"
         continue
      elif [ -z "${USERNAME}" ]
      then
            echo "No username set. Continue"
            continue
      elif [ -z "${PASSWORD}" ] && [ -z "${SSH_KEY}" ] 
      then
            echo "No password or ssh key set. Continue" 
            continue
      elif [ -z "${PASSWORD}" ]
      then
            echo "No password set, just key"
            addsftpuser "$USERNAME"
            echo "${SSH_KEY}" > /etc/ssh-pool/${USERNAME}.pub
      elif [ "${USERNAME}" == "root" ]
      then
            echo "Username not allowed. Continue"
            continue
      elif [ "${USERNAME}" == "ec2-user" ]
      then
            echo "Username not allowed. Continue"
            continue
      elif [ -z "${USERNAME}" ]
      then
            echo "No username set. Continue"
            continue
      elif [ -z "${SSH_KEY}" ]
      then
            echo "No ssh key set, just password"
            addsftpuser "$USERNAME"
            echo "${PASSWORD}" | passwd ${USERNAME} --stdin
      elif ! [ -z "${PASSWORD}" ] && ! [ -z "${SSH_KEY}" ] 
      then
            echo "Password and key both defined. Go with KEY"
            addsftpuser "$USERNAME"
            echo "${SSH_KEY}" > /etc/ssh-pool/${USERNAME}.pub
            echo "${PASSWORD}" | passwd ${USERNAME} --stdin
      else
            echo "Something went wrong. Continue"
            continue
      fi
     
    done < ${IMPORT_FILE}


    sleep 1
    cp $IMPORT_FILE $IMPORT_FILE_PREV

} 100>${FLOCK_FILE}

