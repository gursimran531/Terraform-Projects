#!/bin/bash
set -e

# Update packages
dnf update -y

# Install and start NGINX
dnf install -y nginx --allowerasing
systemctl enable nginx
systemctl start nginx

# Install CloudWatch Agent
dnf install -y amazon-cloudwatch-agent

# Get instance ID
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# CloudWatch config
cat <<EOT > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "/ec2/asg-app-${environment}",
            "log_stream_name": "{INSTANCE_ID}-nginx-access"
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "/ec2/asg-app-${environment}",
            "log_stream_name": "{INSTANCE_ID}-nginx-error"
          }
        ]
      }
    }
  }
}
EOT

# Enable CloudWatch Agent
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

# Ensure SSM Agent is installed (already present on AL2023, but just in case)
dnf install -y amazon-ssm-agent || true
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
