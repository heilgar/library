#!/bin/bash

# Install Apache HTTP Server
sudo yum -y install httpd httpd-devel

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

sudo systemctl start httpd
sudo systemctl enable httpd
