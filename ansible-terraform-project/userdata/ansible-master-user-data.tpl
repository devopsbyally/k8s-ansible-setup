#!/bin/bash

# Log file location
LOG_FILE="/var/log/user-data.log"

# Redirect all output to the log file
exec >> $LOG_FILE 2>&1
echo "$(date +"%Y-%m-%d %H:%M:%S") - Starting user data script."

# Generate SSH key pair for ec2-user
sudo -u ec2-user ssh-keygen -t rsa -N "" -f /home/ec2-user/.ssh/id_rsa


if [ $? -eq 0 ]; then
  echo "SSH key pair generated successfully."
else
  echo " Failed to generate SSH key pair."
  exit 1
fi

# Upload the public key to SSM Parameter Store
echo "$(date +"%Y-%m-%d %H:%M:%S") - Uploading public key to SSM Parameter Store..."
aws ssm put-parameter --name "ansible-master-public-key" \
--value "$(cat /home/ec2-user/.ssh/id_rsa.pub)" \
  --type "String" \
  --overwrite

if [ $? -eq 0 ]; then
  echo "Public key uploaded successfully."
else
  echo "Failed to upload public key to SSM Parameter Store."
  exit 1
fi
# Install ansible on Master node
sudo yum install ansible -y

echo "$(date +"%Y-%m-%d %H:%M:%S") - User data script completed."
