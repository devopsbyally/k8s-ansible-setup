#!/bin/bash

# Log file location
LOG_FILE="/var/log/user-data.log"

# Redirect all output to the log file
exec >> $LOG_FILE 2>&1
echo "$(date +"%Y-%m-%d %H:%M:%S") - Starting user data script."

# Install jq 

sudo yum install jq -y

# Fetch the public key from SSM Parameter Store
echo "$(date +"%Y-%m-%d %H:%M:%S") - Fetching public key from SSM Parameter Store..."
PUBLIC_KEY=$(aws ssm get-parameter --name "ansible-master-public-key" --output json | jq -r '.Parameter.Value')

if [ $? -eq 0 ]; then
  echo "Public key downloaded successfully."
else
  echo "Failed to download public key from SSM Parameter Store."
  exit 1
fi

# Add the public key to the authorized_keys for the ec2-user
echo "$PUBLIC_KEY" >> /home/ec2-user/.ssh/authorized_keys

if [ $? -eq 0 ]; then
  echo "Public key added to authorized_keys."
else
  echo "Failed to add public key to authorized_keys."
  exit 1
fi

echo "$(date +"%Y-%m-%d %H:%M:%S") - User data script completed."
