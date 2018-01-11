#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chown -R ec2-user:ec2-user /var/www
sudo chmod 2775 /var/www
echo "<html><head><meta http-equiv=\"refresh\" content=\"0; url=https://medium.com/slalom-technology/\" /></head></html>" > /var/www/html/index.html