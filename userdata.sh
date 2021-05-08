#!/bin/sh
sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx --now
# Install stress for increasing asg 
sudo amazon-linux-extras install epel
sudo yum install -y stress
echo "<h1>Hello Bobbins!</h1>" | sudo tee /usr/share/nginx/html/index.html
/usr/bin/hostname >> /usr/share/nginx/html/index.html
echo "${project_name}-SFTP.${stage}" >>/usr/share/nginx/html/index.html
