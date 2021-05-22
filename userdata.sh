#!/bin/sh
sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx --now
# Install stress for increasing asg 
sudo amazon-linux-extras install epel
sudo yum update -y 
sudo yum install -y stress zip unzip jq
echo "<h1>Hello Bobbins!</h1>" | sudo tee /usr/share/nginx/html/index.html
/usr/bin/hostname >> /usr/share/nginx/html/index.html
echo "${project_name}-SFTP.${stage}" >>/usr/share/nginx/html/index.html
echo "${bucket_config_name}" >>/usr/share/nginx/html/index.html
sudo /usr/sbin/groupadd sftpusers
sudo mkdir /etc/ssh-pool
#sudo sed -e "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
sudo /usr/bin/sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo echo "Match group sftpusers" >>/etc/ssh/sshd_config
sudo echo "   AllowUsers *" >>/etc/ssh/sshd_config
sudo echo "    X11Forwarding no" >>/etc/ssh/sshd_config
sudo echo "    AllowTcpForwarding no" >>/etc/ssh/sshd_config
sudo echo "    ChrootDirectory %h/uploads" >>/etc/ssh/sshd_config
sudo echo "    ForceCommand internal-sftp" >>/etc/ssh/sshd_config
sudo echo "    AuthorizedKeysFile /etc/ssh-pool/%u.pub" >>/etc/ssh/sshd_config
sudo echo "BUCKET_CONFIG=${bucket_config_name}" >>/etc/sftp_buckets.conf
sudo echo "BUCKET_DATA=${bucket_data_name}" >>/etc/sftp_buckets.conf
sudo echo "DYNAMO_DBTABLE=${dynamo_db_table}" >>/etc/sftp_buckets.conf
sudo echo "AWS_REGION=${aws_region}" >>/etc/sftp_buckets.conf
sudo systemctl restart sshd
sudo aws s3 cp s3://${bucket_config_name}/allconf.zip /tmp
sudo cd / && unzip /tmp/allconf.zip
sudo crontab /tmp/crontab 
