#!/bin/bash
# Update packages
yum update -y

# Install Nginx
amazon-linux-extras enable nginx1
yum install -y nginx

# Start and enable Nginx service
systemctl start nginx
systemctl enable nginx
