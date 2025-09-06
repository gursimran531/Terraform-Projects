#!/bin/bash
# Update system packages
yum update -y

# Install Apache HTTP Server
yum install -y httpd

# Enable Apache to start at boot
systemctl enable httpd

# Start Apache immediately
systemctl start httpd

# Create a simple test page
echo "<h1>Welcome to Apache on Amazon Linux
